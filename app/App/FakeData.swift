import Foundation

/// Phase 0 fake trains: one every 30 minutes from `base`, cycling through the card states
/// so every update shows a different case on the Lock Screen.
enum FakeData {
    static let route = "Monza → Cernusco Merate"
    static let walkMinutes = 10
    static let tripMinutes = 19
    /// D-41: a card leaves 5 minutes after departure.
    static let keepAfterDeparture: TimeInterval = 5 * 60

    static func state(base: Date, updateCount: Int, now: Date = .now) -> TrainActivityAttributes.ContentState {
        var trains: [TrainInfo] = []
        var index = 0
        while trains.count < 2 && index < 100 {
            let train = makeTrain(index: index, base: base, updateCount: updateCount)
            if train.departure.addingTimeInterval(keepAfterDeparture) > now {
                trains.append(train)
            }
            index += 1
        }
        return .init(trains: trains, updatedAt: now, realtimeUnavailable: false, updateCount: updateCount)
    }

    private static func makeTrain(index: Int, base: Date, updateCount: Int) -> TrainInfo {
        let scheduled = base.addingTimeInterval(Double(index) * 30 * 60)
        let phase = updateCount % 6
        let isFirstOfPair = index % 2 == 0

        var status: TrainInfo.Status = .realtime
        var delay = isFirstOfPair ? [0, 1, 3, 6, 4, 2][phase] : 0
        var platform: String? = "4"
        var platformStatus: TrainInfo.PlatformStatus = .scheduled

        if isFirstOfPair {
            switch phase {
            case 2, 3: platformStatus = .confirmed
            case 4: platform = "6"; platformStatus = .changed
            default: break
            }
        } else {
            switch phase {
            case 3: status = .noRealtime; delay = 0; platform = nil
            case 5: status = .cancelled; platform = nil
            default: break
            }
        }

        let departure = scheduled.addingTimeInterval(Double(delay) * 60)
        return TrainInfo(
            number: String(24856 + index * 2),
            terminus: "Lecco",
            durationMinutes: tripMinutes,
            departure: departure,
            arrival: departure.addingTimeInterval(Double(tripMinutes) * 60),
            delayMinutes: delay,
            status: status,
            platform: platform,
            scheduledPlatform: "4",
            platformStatus: platformStatus,
            leaveAt: departure.addingTimeInterval(-Double(walkMinutes) * 60)
        )
    }
}
