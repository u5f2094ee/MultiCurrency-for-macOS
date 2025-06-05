import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Example fallback adapter using a hypothetical API structure similar to openexchangerates.org
public final class OpenExchangeAPIService: CurrencyAPIService {
    public let identifier = "OpenExchangeAPI"
    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func fetchLatestRates(base: String) async throws -> CurrencyRates {
        let urlStr = "https://openexchangerates.org/api/latest.json?app_id=\(apiKey)&base=\(base)"
        guard let url = URL(string: urlStr) else {
            throw CurrencyAPIError.invalidResponse
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return CurrencyRates(base: base, rates: decoded.rates, lastUpdated: Date())
    }

    private struct Response: Decodable {
        let rates: [String: Double]
    }
}
