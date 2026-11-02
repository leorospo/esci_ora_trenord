import AppIntents

/// Shortcuts action that starts the Live Activity without opening the app (fallback path, V-02).
struct StartMonitoringIntent: LiveActivityIntent {
    static let title: LocalizedStringResource = "Avvia monitoraggio treni"
    static let description = IntentDescription("Avvia la Live Activity con i treni finti della Fase 0, senza aprire l'app.")

    @MainActor
    func perform() async throws -> some IntentResult {
        EventLog.shared.add("Azione di Comandi eseguita")
        LiveActivityController.shared.startObserving()
        LiveActivityController.shared.startNow()
        return .result()
    }
}

struct EsciOraShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartMonitoringIntent(),
            phrases: ["Avvia monitoraggio con \(.applicationName)"],
            shortTitle: "Avvia monitoraggio",
            systemImageName: "tram.fill"
        )
    }
}
