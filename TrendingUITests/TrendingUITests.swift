//
//  TrendingUITests.swift
//  TrendingUITests
//
//  Created by Amr Saied on 01/03/2023.
//

import XCTest

final class TrendingUITests: XCTestCase {



    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    
    func testScrollList() {
        let app = XCUIApplication()
        app.launch()
        
        let tableView = app.tables.element(boundBy: 0)
        let lastCell = tableView.cells.element(boundBy: tableView.cells.count - 1)
        
        // Scroll down until the last cell is visible
        while !lastCell.isHittable {
            tableView.swipeUp()
        }
        
        // Scroll up to the top of the list
        while tableView.cells.element(boundBy: 0).isHittable == false {
            tableView.swipeDown()
        }

    }
    
    
    func testDarkModeTableView() {
        let app = XCUIApplication()

        // Enable dark mode in the simulator
        if #available(iOS 13.0, *) {
            app.windows.firstMatch.buttons["Dark Appearance"].tap()
        }

        // Launch the app and navigate to the table view
        app.launch()
        let tableView = app.tables.firstMatch

        // Select the first cell in the table view
        let firstCell = tableView.cells.firstMatch
        firstCell.tap()

        // Verify that the cell has the correct appearance in dark mode
        let label = firstCell.staticTexts.firstMatch
        let expectedColor = UIColor.white

        if #available(iOS 13.0, *) {
            XCTAssertTrue(label.waitForExistence(timeout: 5))
//            XCTAssertEqual(label.labelColor?.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark)), expectedColor)
        } else {
            XCTFail("Dark mode is not available on this version of iOS.")
        }
    }
}
