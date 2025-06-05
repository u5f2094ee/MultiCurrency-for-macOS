import Foundation

/// Abstraction for a currency API.
public protocol CurrencyAPIService {
    /// Unique identifier for the service.
    var identifier: String { get }

    /// Fetches the latest exchange rates.
    /// - Parameter base: Base currency code (e.g. "USD").
    /// - Returns: CurrencyRates model.
    func fetchLatestRates(base: String) async throws -> CurrencyRates
}

/// Example error type for service failures.
public enum CurrencyAPIError: Error {
    case invalidResponse
    case requestFailed(Error)
}
