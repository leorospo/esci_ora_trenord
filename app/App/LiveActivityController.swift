import ActivityKit
import Foundation

/// Starts, schedules, observes and updates the Phase 0 Live Activities.
@MainActor
final class LiveActivityController: ObservableObject {
    static let shared = LiveActivityController()

    @Published private(set) var activityDescriptions: [String] = []

    private var observedIDs = Set<String>()
    private var isObserving = false
    private var updateTask: Task<Void, Never>?
    private var updateCount = 0
    private var trainsBase = Date.now

    private let attributes = TrainActivityAttributes(route: FakeData.route)

    private init() {}

    // MARK: Observation

    func startObserving() {
        guard !isObserving else { return }
        isObserving = true
        for activity in Activity<TrainActivityAttributes>.activities {
            observe(activity)
        }
        Task {
            for await activity in Activity<TrainActivityAttributes>.activityUpdates {
                self.observe(activity)
            }
        }
    }

    private func observe(_ activity: Activity<TrainActivityAttributes>) {
        guard observedIDs.insert(activity.id).inserted else { return }
        EventLog.shared.add("Live Activity \(shortID(activity)) rilevata: \(describe(activity.activityState))")
        Task {
            for await state in activity.activityStateUpdates {
                self.handle(state, of: activity)
            }
        }
        if activity.activityState == .active {
            beginMonitoring()
        }
        refreshDescriptions()
    }

    private func handle(_ state: ActivityState, of activity: Activity<TrainActivityAttributes>) {
        EventLog.shared.add("Live Activity \(shortID(activity)): \(describe(state))")
        switch state {
        case .active:
            beginMonitoring()
        case .dismissed, .ended:
            if !hasActiveActivity {
                stopMonitoring(reason: "nessuna Live Activity attiva")
            }
        default:
            break
        }
        refreshDescriptions()
    }

    // MARK: Start and schedule

    func startNow() {
        let content = ActivityContent(
            state: FakeData.state(base: .now.addingTimeInterval(20 * 60), updateCount: 0),
            staleDate: .now.addingTimeInterval(5 * 60)
        )
        do {
            let activity = try Activity.request(attributes: attributes, content: content, pushType: nil)
            EventLog.shared.add("Avvio immediato riuscito: \(shortID(activity))")
            observe(activity)
        } catch {
            EventLog.shared.add("Avvio immediato fallito: \(error.localizedDescription)")
        }
    }

    func schedule(after interval: TimeInterval) {
        let start = Date.now.addingTimeInterval(interval)
        let content = ActivityContent(
            state: FakeData.state(base: start.addingTimeInterval(20 * 60), updateCount: 0, now: start),
            staleDate: start.addingTimeInterval(5 * 60)
        )
        let alert = AlertConfiguration(
            title: "Esci ora",
            body: "Monitoraggio dei treni avviato",
            sound: .default
        )
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: content,
                pushType: nil,
                style: .standard,
                alertConfiguration: alert,
                start: start
            )
            EventLog.shared.add("Programmata \(shortID(activity)) per \(start.formatted(date: .abbreviated, time: .shortened))")
            observe(activity)
        } catch {
            EventLog.shared.add("Programmazione fallita: \(error.localizedDescription)")
        }
    }

    func endAll() async {
        for activity in Activity<TrainActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        EventLog.shared.add("Terminate tutte le Live Activity dall'app")
        stopMonitoring(reason: "terminate dall'app")
        refreshDescriptions()
    }

    // MARK: Monitoring window

    private func beginMonitoring() {
        guard updateTask == nil else { return }
        trainsBase = .now.addingTimeInterval(20 * 60)
        updateCount = 0
        LocationKeeper.shared.start()
        EventLog.shared.add("Monitoraggio avviato")
        updateTask = Task {
            var nextRequest = Date.now
            while !Task.isCancelled {
                let isRequest = Date.now >= nextRequest
                if isRequest {
                    // D-33: one real-time request every 90 seconds, ±15 seconds.
                    nextRequest = .now.addingTimeInterval(90 + Double.random(in: -15...15))
                }
                await self.sendUpdate(isRequest: isRequest)
                // The Lock Screen view is only redrawn on updates: also wake up when a card
                // must switch to "Esci ora" or leave (D-41), without an extra request.
                let wakeUp = min(nextRequest, self.nextCardChange(after: .now) ?? nextRequest)
                try? await Task.sleep(for: .seconds(max(1, wakeUp.timeIntervalSinceNow + 1)))
            }
        }
    }

    private func nextCardChange(after now: Date) -> Date? {
        FakeData.state(base: trainsBase, updateCount: updateCount, now: now).trains
            .flatMap { [$0.leaveAt, $0.departure.addingTimeInterval(FakeData.keepAfterDeparture)] }
            .filter { $0 > now }
            .min()
    }

    private func stopMonitoring(reason: String) {
        guard updateTask != nil else { return }
        updateTask?.cancel()
        updateTask = nil
        LocationKeeper.shared.stop()
        EventLog.shared.add("Monitoraggio fermato: \(reason)")
    }

    private func sendUpdate(isRequest: Bool) async {
        if isRequest { updateCount += 1 }
        let content = ActivityContent(
            state: FakeData.state(base: trainsBase, updateCount: updateCount),
            staleDate: .now.addingTimeInterval(5 * 60)
        )
        let active = Activity<TrainActivityAttributes>.activities.filter { $0.activityState == .active || $0.activityState == .stale }
        for activity in active {
            await activity.update(content)
        }
        EventLog.shared.add(isRequest
            ? "Aggiornamento \(updateCount) inviato a \(active.count) Live Activity"
            : "Ridisegno per cambio di stato della card (\(active.count) Live Activity)")
    }

    // MARK: Helpers

    private var hasActiveActivity: Bool {
        Activity<TrainActivityAttributes>.activities.contains { $0.activityState == .active || $0.activityState == .stale }
    }

    private func refreshDescriptions() {
        activityDescriptions = Activity<TrainActivityAttributes>.activities.map {
            "\(shortID($0)) – \(describe($0.activityState))"
        }
    }

    private func shortID(_ activity: Activity<TrainActivityAttributes>) -> String {
        String(activity.id.prefix(6))
    }

    private func describe(_ state: ActivityState) -> String {
        switch state {
        case .active: return "attiva"
        case .ended: return "terminata"
        case .dismissed: return "rimossa"
        case .stale: return "contenuto scaduto"
        case .pending: return "programmata"
        @unknown default: return "sconosciuto"
        }
    }
}
