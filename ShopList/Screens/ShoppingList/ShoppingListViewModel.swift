//
//  ShoppingListViewModel.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//

import UIKit

final class ShoppingListViewModel {
    var shoppingItems: [ShoppingItem] = []
    var isEmpty: Bool { shoppingItems.isEmpty }
}
