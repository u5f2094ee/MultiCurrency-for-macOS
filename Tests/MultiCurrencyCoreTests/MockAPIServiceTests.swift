import XCTest
@testable import MultiCurrencyCore

final class MockAPIServiceTests: XCTestCase {
    func testSuccess() async throws {
        let rates = CurrencyRates(base: "USD", rates: ["EUR": 1.0], lastUpdated: Date())
        let api = MockAPIService(identifier: "mock", result: .success(rates))
        let fetched = try await api.fetchLatestRates(base: "USD")
        XCTAssertEqual(fetched.rates["EUR"], 1.0)
    }

    func testFailure() async {
        let api = MockAPIService(identifier: "mock", result: .failure(CurrencyAPIError.invalidResponse))
        do {
            _ = try await api.fetchLatestRates(base: "USD")
            XCTFail("Expected failure")
        } catch {
            // success
        }
    }
}
