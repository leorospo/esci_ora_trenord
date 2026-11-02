import SwiftUI
import UIKit

@main
struct EsciOraApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .onChange(of: scenePhase) { _, phase in
            EventLog.shared.add("Fase dell'app: \(describe(phase))")
        }
    }

    private func describe(_ phase: ScenePhase) -> String {
        switch phase {
        case .active: return "attiva"
        case .inactive: return "inattiva"
        case .background: return "background"
        @unknown default: return "?"
        }
    }
}

/// Logs every process launch, including the ones without UI (scheduled start, Shortcuts, location).
final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        let keys = launchOptions?.keys.map(\.rawValue).joined(separator: ", ") ?? ""
        EventLog.shared.add("Processo avviato (\(keys.isEmpty ? "avvio normale" : keys))")
        LiveActivityController.shared.startObserving()
        return true
    }
}
