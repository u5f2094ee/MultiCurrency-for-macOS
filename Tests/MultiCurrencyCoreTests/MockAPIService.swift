import Foundation
@testable import MultiCurrencyCore

struct MockAPIService: CurrencyAPIService {
    let identifier: String
    var result: Result<CurrencyRates, Error>

    func fetchLatestRates(base: String) async throws -> CurrencyRates {
        switch result {
        case .success(let rates):
            return rates
        case .failure(let error):
            throw error
        }
    }
}
