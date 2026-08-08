//
//  ShoppingItemEntity+CoreDataClass.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 08.08.2026.
//
//

public import Foundation
public import CoreData

public typealias ShoppingItemEntityCoreDataClassSet = NSSet

@objc(ShoppingItemEntity)
public class ShoppingItemEntity: NSManagedObject {
    convenience init(context: NSManagedObjectContext, title: String) {
        self.init(context: context)
        self.id = UUID()
        self.title = title
        self.isChecked = false
    }
}
