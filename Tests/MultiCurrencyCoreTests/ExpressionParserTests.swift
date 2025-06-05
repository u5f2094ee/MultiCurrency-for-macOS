import XCTest
@testable import MultiCurrencyCore

final class ExpressionParserTests: XCTestCase {
    func testValidExpression() {
        XCTAssertEqual(ExpressionParser.evaluate("5*3+10"), 25)
        XCTAssertEqual(ExpressionParser.evaluate("2 + 2 * 2"), 6)
    }

    func testInvalidExpression() {
        XCTAssertNil(ExpressionParser.evaluate("5**"))
        XCTAssertNil(ExpressionParser.evaluate("abc"))
    }
}
