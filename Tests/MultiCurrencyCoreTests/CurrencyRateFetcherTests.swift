import XCTest
@testable import MultiCurrencyCore

final class CurrencyRateFetcherTests: XCTestCase {
    func testFallbackMechanism() async {
        let failureService = MockAPIService(identifier: "primary", result: .failure(CurrencyAPIError.invalidResponse))
        let successRates = CurrencyRates(base: "USD", rates: ["EUR": 0.9], lastUpdated: Date())
        let successService = MockAPIService(identifier: "fallback", result: .success(successRates))
        let fetcher = CurrencyRateFetcher(primary: failureService, fallbacks: [successService])
        let rates = await fetcher.fetchRates(base: "USD")
        XCTAssertEqual(rates?.rates["EUR"], 0.9)
    }

    func testCacheUsedOnFailure() async {
        let cached = CurrencyRates(base: "USD", rates: ["JPY": 150], lastUpdated: Date())
        PersistenceManager.shared.saveCachedRates(cached)
        let failureService = MockAPIService(identifier: "primary", result: .failure(CurrencyAPIError.invalidResponse))
        let fetcher = CurrencyRateFetcher(primary: failureService)
        let rates = await fetcher.fetchRates(base: "USD")
        XCTAssertEqual(rates?.rates["JPY"], 150)
    }
}
