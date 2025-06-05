import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Example adapter for the ExchangeRate-API service.
public final class ExchangeRateAPIService: CurrencyAPIService {
    public let identifier = "ExchangeRateAPI"
    private let apiKey: String

    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    public func fetchLatestRates(base: String) async throws -> CurrencyRates {
        let urlStr = "https://v6.exchangerate-api.com/v6/\(apiKey)/latest/\(base)"
        guard let url = URL(string: urlStr) else {
            throw CurrencyAPIError.invalidResponse
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(Response.self, from: data)
        return CurrencyRates(base: base, rates: decoded.conversionRates, lastUpdated: Date())
    }

    private struct Response: Decodable {
        let conversionRates: [String: Double]

        enum CodingKeys: String, CodingKey {
            case conversionRates = "conversion_rates"
        }
    }
}
