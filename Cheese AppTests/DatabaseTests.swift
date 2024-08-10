import XCTest
@testable import Cheese_App  // Import your project module
class UtilitiesTests: XCTestCase {

    func testGetAllCheeses() async {
        // Test case 1: Positive number
        let db = Database()
        let results = await db.getAllCheeses()
        print(results[0])
        XCTAssert(results.count > 0)
    }
    
    func testGetAllCategories() async {
        let db = Database()
        let results = await db.getAllCategories()
        print(results[1])
        XCTAssert(results.count > 0)
    }
    
    func testGetAllGateways() async {
        let db = Database()
        let results = await db.getAllGateways()
        print(results[0])
        XCTAssert(results.count > 0)
    }
}
