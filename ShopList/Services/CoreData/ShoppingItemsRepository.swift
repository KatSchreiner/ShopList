//
//  ShoppingItemsRepository.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 08.08.2026.
//

import Foundation
import CoreData

final class ShoppingItemsRepository {
    private let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager = .shared) {
        self.coreDataManager = coreDataManager
    }
    
    private func save() throws {
        self.coreDataManager.saveContext()
    }
    
    func fetchAll() throws -> [ShoppingItem] {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        let entities = try coreDataManager.context.fetch(request)
        
        return entities.map {
            ShoppingItem(
                id: $0.id,
                title: $0.title,
                isChecked: $0.isChecked
            )
        }
    }
    
    func addItem(title: String) throws {
        guard !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ShoppingItemError.emptyTitle
        }
        _ = ShoppingItemEntity(context: coreDataManager.context, title: title)
        try save()
    }
    
    func toggleItem(forId id: UUID) throws {
        let request: NSFetchRequest<ShoppingItemEntity> = ShoppingItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        
        let results = try coreDataManager.context.fetch(request)
        guard let entity = results.first else {
            throw ShoppingItemError.itemNotFound(id: id)
        }
        
        entity.isChecked.toggle()
        try save()
    }
    
    func clearAll() throws {
        let request = ShoppingItemEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request as! NSFetchRequest<any NSFetchRequestResult>)
        
        do {
            try coreDataManager.context.persistentStoreCoordinator?.execute(deleteRequest, with: coreDataManager.context)
        } catch {
            throw ShoppingItemError.persistence(error)
        }
    }
}
