//
//  Items.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 20.07.2026.
//
import UIKit

struct ShoppingItem: Identifiable, Codable {
    var id: UUID
    var title: String
    var isChecked: Bool
}
