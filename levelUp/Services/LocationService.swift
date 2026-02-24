import Foundation
import CoreLocation
import Combine

/// Errors that can occur while working with location services.
enum LocationError: LocalizedError {
    case servicesDisabled
    case permissionDenied
    case unableToFetch

    var errorDescription: String? {
        switch self {
        case .servicesDisabled:
            return "Location services are disabled. Please enable them in Settings."
        case .permissionDenied:
            return "Location permission was denied. Please allow access in Settings."
        case .unableToFetch:
            return "Unable to determine your location right now. Please try again."
        }
    }
}

/// Thin wrapper around `CLLocationManager` that exposes an async API
/// suitable for use from ViewModels and services.
///
/// Permission dialog only appears when requestWhenInUseAuthorization() is called
/// on the main thread. This class ensures that and resumes the async continuation
/// only when the user has made a choice (status != .notDetermined).
final class LocationService: NSObject, ObservableObject {

    @Published private(set) var authorizationStatus: CLAuthorizationStatus
    @Published private(set) var lastError: LocationError?

    private let manager: CLLocationManager

    private var authorizationContinuation: CheckedContinuation<Void, Never>?
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?

    override init() {
        let manager = CLLocationManager()
        self.manager = manager
        self.authorizationStatus = manager.authorizationStatus
        super.init()

        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer

        #if DEBUG
        print("[LocationService] init – authorizationStatus: \(manager.authorizationStatus.description)")
        #endif
    }

    /// Requests authorization if the status is `.notDetermined`.
    /// Returns immediately if authorization has already been decided (e.g. denied/authorized).
    /// If already denied/restricted, no system dialog is shown; check authorizationStatus or lastError.
    func requestAuthorizationIfNeeded() async {
        guard CLLocationManager.locationServicesEnabled() else {
            lastError = .servicesDisabled
            #if DEBUG
            print("[LocationService] requestAuthorizationIfNeeded – location services disabled")
            #endif
            return
        }

        let current = authorizationStatus

        #if DEBUG
        print("[LocationService] requestAuthorizationIfNeeded – current status: \(current.description)")
        #endif

        switch current {
        case .notDetermined:
            await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
                authorizationContinuation = continuation
                // CRITICAL: requestWhenInUseAuthorization() must be called on the main thread,
                // otherwise the system permission dialog may never appear (especially when
                // this async method is run on a background cooperative thread).
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    #if DEBUG
                    print("[LocationService] requestWhenInUseAuthorization() called on main thread")
                    #endif
                    self.manager.requestWhenInUseAuthorization()
                }
            }
        case .denied, .restricted:
            lastError = .permissionDenied
            #if DEBUG
            print("[LocationService] requestAuthorizationIfNeeded – already denied/restricted, popup will not show again")
            #endif
        case .authorizedAlways, .authorizedWhenInUse:
            #if DEBUG
            print("[LocationService] requestAuthorizationIfNeeded – already authorized")
            #endif
            break
        @unknown default:
            break
        }
    }

    /// Returns the user's current coordinates or throws a `LocationError`
    /// if services are disabled, permission is denied, or a location
    /// cannot be obtained.
    func getCurrentCoordinates() async throws -> (lat: Double, lon: Double) {
        guard CLLocationManager.locationServicesEnabled() else {
            lastError = .servicesDisabled
            throw LocationError.servicesDisabled
        }

        // Ensure we have (or at least have requested) permission.
        if authorizationStatus == .notDetermined {
            await requestAuthorizationIfNeeded()
        }

        switch authorizationStatus {
        case .denied, .restricted:
            lastError = .permissionDenied
            throw LocationError.permissionDenied
        default:
            break
        }

        let location: CLLocation = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<CLLocation, Error>) in
            locationContinuation = continuation
            manager.requestLocation()
        }

        return (lat: location.coordinate.latitude, lon: location.coordinate.longitude)
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let newStatus = manager.authorizationStatus

        // Delegate can be called on a background thread; update @Published and resume on main.
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.authorizationStatus = newStatus

            #if DEBUG
            print("[LocationService] locationManagerDidChangeAuthorization – new status: \(newStatus.description)")
            #endif

            // Only resume when the user has actually made a choice (status is no longer .notDetermined).
            // Otherwise we might resume too early if the delegate fires with .notDetermined before the dialog is shown.
            guard newStatus != .notDetermined, let continuation = self.authorizationContinuation else {
                return
            }
            self.authorizationContinuation = nil
            continuation.resume()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil

        if let location = locations.last {
            continuation.resume(returning: location)
        } else {
            lastError = .unableToFetch
            continuation.resume(throwing: LocationError.unableToFetch)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        guard let continuation = locationContinuation else { return }
        locationContinuation = nil

        lastError = .unableToFetch
        continuation.resume(throwing: LocationError.unableToFetch)
    }
}

// MARK: - Debug (authorization status string for logs)

private extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined: return "notDetermined"
        case .restricted: return "restricted"
        case .denied: return "denied"
        case .authorizedAlways: return "authorizedAlways"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        @unknown default: return "unknown"
        }
    }
}

