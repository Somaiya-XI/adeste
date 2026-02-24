import Foundation
import Adhan

/// Factory responsible for creating `PrayerTimesProviding` instances
/// from geographic coordinates.
struct PrayerTimesProviderFactory {
    var calculationMethod: CalculationMethod = .muslimWorldLeague
    var madhab: Madhab = .shafi

    func makeProvider(lat: Double, lon: Double) -> PrayerTimesProviding {
        var provider = AdhanPrayerTimesProvider(latitude: lat, longitude: lon)
        provider.calculationMethod = calculationMethod
        provider.madhab = madhab
        return provider
    }
}

/// A `PrayerTimesProviding` implementation that derives prayer times
/// from the user's current location via `LocationService`.
struct LocationBasedPrayerTimesProvider: PrayerTimesProviding {
    let locationService: LocationService
    let factory: PrayerTimesProviderFactory

    func prayerTimes(for dayStart: Date) async throws -> PrayerTimesDay {
        // Fetch current coordinates (throws `LocationError` if unavailable).
        let coords = try await locationService.getCurrentCoordinates()

        // Build a concrete Adhan provider for these coordinates.
        let provider = factory.makeProvider(lat: coords.lat, lon: coords.lon)

        // Delegate to the existing Adhan-based implementation.
        return try await provider.prayerTimes(for: dayStart)
    }
}

