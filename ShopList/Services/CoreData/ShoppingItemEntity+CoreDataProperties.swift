//
//  ShoppingItemEntity+CoreDataProperties.swift
//  ShopList
//
//  Created by Екатерина Шрайнер on 08.08.2026.
//
//

public import Foundation
public import CoreData


public typealias ShoppingItemEntityCoreDataPropertiesSet = NSSet

extension ShoppingItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingItemEntity> {
        return NSFetchRequest<ShoppingItemEntity>(entityName: "ShoppingItemEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var isChecked: Bool
    @NSManaged public var title: String

}

extension ShoppingItemEntity : Identifiable {

}
