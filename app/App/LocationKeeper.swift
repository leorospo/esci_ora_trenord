import CoreLocation
import Foundation

/// Keeps the process alive in background with the lowest location accuracy.
/// Location is only a means to stay running; positions are ignored and never stored.
@MainActor
final class LocationKeeper: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationKeeper()

    @Published private(set) var authorization: CLAuthorizationStatus = .notDetermined
    @Published private(set) var isRunning = false

    private let manager = CLLocationManager()
    private var backgroundSession: CLBackgroundActivitySession?

    private override init() {
        super.init()
        authorization = manager.authorizationStatus
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        manager.distanceFilter = kCLDistanceFilterNone
        manager.pausesLocationUpdatesAutomatically = false
        manager.showsBackgroundLocationIndicator = true
    }

    func requestAuthorization() {
        manager.requestAlwaysAuthorization()
    }

    func start() {
        guard !isRunning else { return }
        manager.allowsBackgroundLocationUpdates = true
        backgroundSession = CLBackgroundActivitySession()
        manager.startUpdatingLocation()
        isRunning = true
        EventLog.shared.add("Posizione avviata (autorizzazione: \(authorizationText))")
        if authorization != .authorizedAlways {
            EventLog.shared.add("Attenzione: senza autorizzazione \"sempre\" la posizione potrebbe non tenere attiva l'app in background")
        }
    }

    func stop() {
        guard isRunning else { return }
        manager.stopUpdatingLocation()
        backgroundSession?.invalidate()
        backgroundSession = nil
        isRunning = false
        EventLog.shared.add("Posizione fermata")
    }

    var authorizationText: String {
        switch authorization {
        case .authorizedAlways: return "sempre"
        case .authorizedWhenInUse: return "mentre usi l'app"
        case .denied: return "negata"
        case .restricted: return "limitata"
        case .notDetermined: return "non richiesta"
        @unknown default: return "?"
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorization = status
            EventLog.shared.add("Autorizzazione posizione: \(self.authorizationText)")
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Positions are not used (requisiti: location only keeps the app alive).
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let message = error.localizedDescription
        Task { @MainActor in
            EventLog.shared.add("Errore posizione: \(message)")
        }
    }
}
