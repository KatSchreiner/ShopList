//
//  CoreDataManager..swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 08.08.2026.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    var context: NSManagedObjectContext { container.viewContext }
    
    private init() {
        container = NSPersistentContainer(name: "ShopList")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Ошибка загрузки CoreData: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
    func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения: \(error.localizedDescription)")
        }
    }
}
