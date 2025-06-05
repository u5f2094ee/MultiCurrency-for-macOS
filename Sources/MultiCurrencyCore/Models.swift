import Foundation

/// Represents exchange rates relative to a base currency.
public struct CurrencyRates: Codable {
    /// Base currency code (e.g. "USD")
    public let base: String
    /// Map of currency codes to rates.
    public let rates: [String: Double]
    /// Timestamp for last update.
    public let lastUpdated: Date
}
