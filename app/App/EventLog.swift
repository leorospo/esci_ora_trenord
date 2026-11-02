import Foundation
import UIKit

/// Persistent event log shown in the app, so Phase 0 results can be read without Xcode.
@MainActor
final class EventLog: ObservableObject {
    static let shared = EventLog()

    struct Entry: Codable, Identifiable {
        var id = UUID()
        var date: Date
        var text: String
    }

    @Published private(set) var entries: [Entry] = []

    private let fileURL = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("registro.json")

    private init() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        if let data = try? Data(contentsOf: fileURL),
           let saved = try? JSONDecoder().decode([Entry].self, from: data) {
            entries = saved
        }
    }

    func add(_ text: String) {
        entries.append(Entry(date: .now, text: "\(text) [\(appStateText), batteria \(batteryText)]"))
        save()
    }

    func clear() {
        entries = []
        save()
    }

    var exportText: String {
        entries
            .map { "\($0.date.formatted(date: .numeric, time: .standard))  \($0.text)" }
            .joined(separator: "\n")
    }

    private var appStateText: String {
        switch UIApplication.shared.applicationState {
        case .active: return "primo piano"
        case .inactive: return "inattiva"
        case .background: return "background"
        @unknown default: return "?"
        }
    }

    private var batteryText: String {
        let level = UIDevice.current.batteryLevel
        return level < 0 ? "?" : "\(Int((level * 100).rounded()))%"
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
