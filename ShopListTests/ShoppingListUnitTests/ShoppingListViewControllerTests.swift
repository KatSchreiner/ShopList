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

    override func setUp() {
        super.setUp()
        sut = ShoppingListViewController()
        _ = sut.view
        sut.viewDidAppear(false)
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
}
