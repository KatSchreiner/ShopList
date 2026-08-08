//
//  ShopListTests.swift
//  ShopListTests
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import XCTest
@testable import ShopList

@MainActor
final class ShoppingListViewControllerTests: XCTestCase {
    var sut: ShoppingListViewController!
    var viewModel: ShoppingListViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = ShoppingListViewModel()
        sut = ShoppingListViewController()
        _ = sut.view
    }
    
    override func tearDown() {
        sut = nil
        viewModel = nil
        super.tearDown()
    }

    func test_emptyList_showsEmptyStateViews() {
        let expectation = expectation(description: "Анимация empty state должна завершиться")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        guard let label = sut.view.subviews.first(where: { $0.accessibilityIdentifier == "EmptyStateLabel" }) else {
            XCTFail("emptyStateLabel не найден в иерархии")
            return
        }

        XCTAssertFalse(label.isHidden)
        XCTAssertGreaterThanOrEqual(label.alpha, 0.9)

        guard let imageView = sut.view.subviews.first(where: { $0.accessibilityIdentifier == "EmptyStateImageView" }) else {
            XCTFail("emptyStateImageView не найден в иерархии")
            return
        }

        XCTAssertFalse(imageView.isHidden)
        XCTAssertGreaterThanOrEqual(imageView.alpha, 0.9)
    }
    
    func test_nonEmptyList_hidesEmptyStateViews() {
        // Given
        _ = sut.view
        sut.viewDidAppear(false)

        sut.viewModel.addShoppingItem(title: "Молоко")

        // When
        sut.viewDidAppear(false)

        //Then
        let expectation = expectation(description: "Анимация скрытия empty state должна завершиться")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        guard let label = sut.view.subviews.first(where: { $0.accessibilityIdentifier == "EmptyStateLabel" }) else {
            XCTFail("emptyStateLabel не найден в иерархии")
            return
        }

        XCTAssertTrue(label.isHidden, "emptyStateLabel должен быть скрыт при непустом списке")
        XCTAssertLessThanOrEqual(label.alpha, 0.1, "emptyStateLabel должен стать почти прозрачным")

        guard let imageView = sut.view.subviews.first(where: { $0.accessibilityIdentifier == "EmptyStateImageView" }) else {
            XCTFail("emptyStateImageView не найден в иерархии")
            return
        }

        XCTAssertTrue(imageView.isHidden, "emptyStateImageView должен быть скрыт при непустом списке")
        XCTAssertLessThanOrEqual(imageView.alpha, 0.1, "emptyStateImageView должен стать почти прозрачным")
    }

    func test_clearListButton_isEmptyState_whenListIsEmpty() {
        // Given
        // When
        sut.viewDidAppear(false)
        
        //Then
        let animationExpectation = expectation(description: "Анимация кнопки должна завершиться")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            animationExpectation.fulfill()
        }
        wait(for: [animationExpectation], timeout: 1.0)
        
        XCTAssertTrue(sut.isClearButtonInEmptyState(), "Кнопка должна быть в пустом состоянии")
    }
}
