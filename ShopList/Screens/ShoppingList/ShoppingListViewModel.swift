//
//  ShoppingListViewModel.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

final class ShoppingListViewModel {
    private let repository: ShoppingItemsRepository
    
    init(repository: ShoppingItemsRepository = .shared) {
        self.repository = repository
        reloadItems()
    }
    
    private(set) var shoppingItems: [ShoppingItem] = []
    
    var isEmpty: Bool {
        shoppingItems.isEmpty
    }

    func reloadItems() {
        shoppingItems = repository.fetchAll()
    }
    
    func addShoppingItem(title: String) {
        repository.addItem(title: title)
        reloadItems()
    }
    
    func clearList() {
        repository.clearAll()
        reloadItems()
    }
    
    func toggleItemChecked(id: UUID) {
        repository.toggleItem(forId: id)
        reloadItems()
    }
}
