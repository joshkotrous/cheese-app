import XCTest
@testable import Cheese_App  // Import your project module
class UtilitiesTests: XCTestCase {

    func testGetAllCheeses() async {
        // Test case 1: Positive number
        let db = Database()
        let results = await db.getAllCheeses()
        print(results)
        XCTAssert(results.count > 0)
    }
}
