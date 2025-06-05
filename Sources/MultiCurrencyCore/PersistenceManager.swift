import Foundation

/// Manages persistence using UserDefaults.
public final class PersistenceManager {
    public static let shared = PersistenceManager()

    private let favoritesKey = "favorites"
    private let providerKey = "selectedProvider"
    private let cachedRatesKey = "cachedRates"

    private var defaults: UserDefaults { .standard }

    private init() {}

    // MARK: Favorites

    public var favoriteCurrencies: [String] {
        get { defaults.stringArray(forKey: favoritesKey) ?? [] }
        set { defaults.set(newValue, forKey: favoritesKey) }
    }

    // MARK: Selected Provider

    public var selectedProviderIdentifier: String? {
        get { defaults.string(forKey: providerKey) }
        set { defaults.set(newValue, forKey: providerKey) }
    }

    // MARK: Cached Rates

    public func saveCachedRates(_ rates: CurrencyRates) {
        if let data = try? JSONEncoder().encode(rates) {
            defaults.set(data, forKey: cachedRatesKey)
        }
    }

    public func loadCachedRates() -> CurrencyRates? {
        guard let data = defaults.data(forKey: cachedRatesKey),
              let rates = try? JSONDecoder().decode(CurrencyRates.self, from: data) else {
            return nil
        }
        return rates
    }
}
