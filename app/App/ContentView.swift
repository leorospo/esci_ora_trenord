import SwiftUI

/// Phase 0 test console: start or schedule Live Activities, check location, read the event log.
struct ContentView: View {
    @ObservedObject private var log = EventLog.shared
    @ObservedObject private var controller = LiveActivityController.shared
    @ObservedObject private var location = LocationKeeper.shared
    @State private var delay: ScheduleDelay = .oneMinute

    var body: some View {
        NavigationStack {
            List {
                Section("Live Activity") {
                    Button("Avvia ora") { controller.startNow() }
                    Picker("Programma tra", selection: $delay) {
                        ForEach(ScheduleDelay.allCases) { Text($0.label).tag($0) }
                    }
                    Button("Programma") { controller.schedule(after: delay.seconds) }
                    Button("Termina tutte", role: .destructive) {
                        Task { await controller.endAll() }
                    }
                    ForEach(controller.activityDescriptions, id: \.self) { description in
                        Text(description).font(.footnote.monospaced())
                    }
                }

                Section("Posizione") {
                    LabeledContent("Autorizzazione", value: location.authorizationText)
                    LabeledContent("Attiva", value: location.isRunning ? "sì" : "no")
                    Button("Chiedi autorizzazione") { location.requestAuthorization() }
                }

                Section("Registro") {
                    ForEach(log.entries.reversed()) { entry in
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.date.formatted(date: .abbreviated, time: .standard))
                                .font(.caption.monospaced())
                                .foregroundStyle(.secondary)
                            Text(entry.text).font(.footnote)
                        }
                    }
                }
            }
            .navigationTitle("Esci ora · Fase 0")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Svuota") { log.clear() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: log.exportText)
                }
            }
        }
    }
}

enum ScheduleDelay: String, CaseIterable, Identifiable {
    case oneMinute
    case tenMinutes
    case oneHour
    case twelveHours
    case twentyFourHours

    var id: String { rawValue }

    var label: String {
        switch self {
        case .oneMinute: return "1 minuto"
        case .tenMinutes: return "10 minuti"
        case .oneHour: return "1 ora"
        case .twelveHours: return "12 ore"
        case .twentyFourHours: return "24 ore"
        }
    }

    var seconds: TimeInterval {
        switch self {
        case .oneMinute: return 60
        case .tenMinutes: return 10 * 60
        case .oneHour: return 60 * 60
        case .twelveHours: return 12 * 60 * 60
        case .twentyFourHours: return 24 * 60 * 60
        }
    }
}
