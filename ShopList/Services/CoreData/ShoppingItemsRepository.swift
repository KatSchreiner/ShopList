//
//  ShoppingItemsRepository.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 08.08.2026.
//

import Foundation
import CoreData

final class ShoppingItemsRepository {
    static let shared = ShoppingItemsRepository()
    
    private let context: NSManagedObjectContext
    
    private init() {
        self.context = CoreDataManager.shared.context
    }
    
    func fetchAll() -> [ShoppingItem] {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            let entities = try context.fetch(request)
            return entities.map {
                ShoppingItem(
                    id: $0.id,
                    title: $0.title,
                    isChecked: $0.isChecked
                )
            }
        } catch {
            print("Ошибка выборки: \(error.localizedDescription)")
            return []
        }
    }
    
    func addItem(title: String) {
        _ = ShoppingItemEntity(context: context, title: title)
        save()
    }
    
    private func save() {
        CoreDataManager.shared.saveContext()
    }
}
