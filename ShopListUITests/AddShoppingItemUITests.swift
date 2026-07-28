//
//  AddShoppingItemUITests.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 28.07.2026.
//

import XCTest

final class AddShoppingItemUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    @MainActor
    func testScreenRendersCorrectly() throws {
        let app = XCUIApplication()
        app.launch()
        
        let addItemButton = app.buttons["AddItemButton"]
        XCTAssertTrue(addItemButton.exists, "Кнопка 'Добавить' не найдена")
        addItemButton.tap()
        
        XCTAssertTrue(app.textFields["ItemNameTextField"].exists, "Поле для ввода названия товара не найдено")
        XCTAssertTrue(app.buttons["AddItemVoiceButton"].exists, "Кнопка 'Голосовое добавление' не найдена")
        XCTAssertTrue(app.buttons["SendItemButton"].exists, "Кнопка 'Отправить' не найдена")
    }
}
