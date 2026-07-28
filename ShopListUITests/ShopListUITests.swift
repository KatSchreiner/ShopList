//
//  ShopListUITests.swift
//  ShopListUITests
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import XCTest

final class ShopListUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testScreenRendersCorrectly() throws {
        let app = XCUIApplication()
        app.launch()
        
        XCTAssertTrue(app.buttons["AddItemButton"].exists, "Кнопка добавить не найдена — возможно, не добавлена в view или constraints не активированы")
        XCTAssertTrue(app.tables["ShoppingItemsTableView"].exists, "Таблица отсутствует на экране")
        
        let predicate = NSPredicate(format: "label CONTAINS 'Пока тут тихо'")
        let emptyLabel = app.staticTexts.matching(predicate)
        XCTAssertTrue(emptyLabel.element.exists, "Лейбл пустого состояния должен быть виден, когда список пуст")
    }
    
    @MainActor
    func testTappingAddItemButton() throws {
        let app = XCUIApplication()
        app.launch()
        
        let addItemButton = app.buttons["AddItemButton"]
        XCTAssertTrue(addItemButton.exists, "Кнопка добавить не найдена")
        
        addItemButton.tap()
        
        let modalTitle = app.staticTexts.matching(identifier: "AddItemModalTitle").element
        XCTAssertTrue(modalTitle.waitForExistence(timeout: 5.0), "Модальное окно не появилось после нажатия кнопки")
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
