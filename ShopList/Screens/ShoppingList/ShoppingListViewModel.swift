//
//  ShoppingListViewModel.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

final class ShoppingListViewModel {
    private(set) var shoppingItems: [ShoppingItem] = []
    
    var isEmpty: Bool { shoppingItems.isEmpty }

    func addShoppingItem(title: String) {
        let newItem = ShoppingItem(id: UUID(), title: title, isChecked: false)
        shoppingItems.append(newItem)
    }
}
