import Foundation

/// Manages fetching currency rates with fallback providers and caching.
public final actor CurrencyRateFetcher {
    private let primary: CurrencyAPIService
    private let fallbacks: [CurrencyAPIService]
    private let persistence = PersistenceManager.shared

    public init(primary: CurrencyAPIService, fallbacks: [CurrencyAPIService] = []) {
        self.primary = primary
        self.fallbacks = fallbacks
    }

    /// Fetch latest rates using primary provider, falling back to others on failure.
    public func fetchRates(base: String) async -> CurrencyRates? {
        let services = [primary] + fallbacks
        for service in services {
            do {
                let rates = try await service.fetchLatestRates(base: base)
                persistence.saveCachedRates(rates)
                return rates
            } catch {
                // try next service
                continue
            }
        }
        // all failed
        return persistence.loadCachedRates()
    }
}
