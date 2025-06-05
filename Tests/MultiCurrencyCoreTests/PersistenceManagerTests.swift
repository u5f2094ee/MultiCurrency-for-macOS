import XCTest
@testable import MultiCurrencyCore

final class PersistenceManagerTests: XCTestCase {
    func testSaveAndLoadFavorites() {
        let pm = PersistenceManager.shared
        pm.favoriteCurrencies = ["USD", "EUR"]
        XCTAssertEqual(pm.favoriteCurrencies, ["USD", "EUR"])
    }

    func testSaveAndLoadProvider() {
        let pm = PersistenceManager.shared
        pm.selectedProviderIdentifier = "ExchangeRateAPI"
        XCTAssertEqual(pm.selectedProviderIdentifier, "ExchangeRateAPI")
    }

    func testSaveAndLoadCachedRates() {
        let pm = PersistenceManager.shared
        let rates = CurrencyRates(base: "USD", rates: ["GBP": 0.8], lastUpdated: Date())
        pm.saveCachedRates(rates)
        XCTAssertEqual(pm.loadCachedRates()?.rates["GBP"], 0.8)
    }
}
