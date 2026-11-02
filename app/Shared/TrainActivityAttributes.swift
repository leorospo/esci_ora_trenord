import ActivityKit
import Foundation

/// Data shared between the app and the Live Activity extension.
struct TrainActivityAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var trains: [TrainInfo]
        var updatedAt: Date
        /// Global error: real-time feed unreachable (D-49).
        var realtimeUnavailable: Bool
        /// Phase 0 only: counts updates, shown in the footer to check background delivery.
        var updateCount: Int
    }

    var route: String
}

struct TrainInfo: Codable, Hashable, Identifiable {
    enum Status: String, Codable, Hashable {
        case realtime
        case noRealtime
        case cancelled
    }

    enum PlatformStatus: String, Codable, Hashable {
        case scheduled
        case confirmed
        case changed
    }

    var id: String { number }
    var number: String
    var terminus: String
    var durationMinutes: Int
    var departure: Date
    var arrival: Date
    var delayMinutes: Int
    var status: Status
    var platform: String?
    var scheduledPlatform: String?
    var platformStatus: PlatformStatus
    /// Departure minus the walk to the station: drives "Esci tra" / "Esci ora".
    var leaveAt: Date
}
