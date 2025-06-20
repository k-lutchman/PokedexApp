import XCTest

final class PokedexAppUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }
    
    func testPokemonDetailsNavigation() {
        let app = XCUIApplication()
        app.launch()

        let detailsButton = app.buttons["PokemonDetailsButton"]
        XCTAssertTrue(detailsButton.waitForExistence(timeout: 10))
        detailsButton.tap()
        
        let detailsLabel = app.staticTexts["Description:"]
        XCTAssertTrue(detailsLabel.waitForExistence(timeout: 10))
    }
}
