//
//  ShoppingListViewModel.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

final class ShoppingListViewModel {
    private let repository: ShoppingItemsRepository
    
    init(repository: ShoppingItemsRepository ) {
        self.repository = repository
    }
    
    private(set) var shoppingItems: [ShoppingItem] = []
    
    var isEmpty: Bool {
        shoppingItems.isEmpty
    }

    func reloadItems() throws {
        shoppingItems = try repository.fetchAll()
    }
    
    func addShoppingItem(title: String) throws {
        try repository.addItem(title: title)
        try reloadItems()
    }
    
    func deleteShopping(id: UUID) throws {
        try repository.deleteItem(id: id)
        
        try reloadItems()
    }
    
    func clearList() throws {
        try repository.clearAll()
        try reloadItems()
    }
    
    func toggleItemChecked(id: UUID) throws {
        try repository.toggleItem(forId: id)
        try reloadItems()
    }
}
