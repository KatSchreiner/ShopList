//
//  ShoppingItemError.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 09.08.2026.
//

import Foundation

enum ShoppingItemError: LocalizedError {
    case itemNotFound(id: UUID)
    case invalidRequest
    case emptyTitle
    case persistence(Error)
    
    var errorDescription: String? {
        switch self {
        case .itemNotFound(let id):
            return "Товар с ID \(id) не найден"
        case .invalidRequest:
            return "Некорректный запрос к хранилищу"
        case .emptyTitle:
            return "Название товара не может быть пустым"
        case .persistence(let underlyingError):
            return "Не удалось сохранить данные: \(underlyingError.localizedDescription)"
        }
    }
}
