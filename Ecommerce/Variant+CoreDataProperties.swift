//
//  Variant+CoreDataProperties.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import Foundation
import CoreData


extension Variant {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Variant> {
        return NSFetchRequest<Variant>(entityName: "Variant")
    }

    @NSManaged public var variantColor: String?
    @NSManaged public var variantID: Int16
    @NSManaged public var variantPrize: Int32
    @NSManaged public var variantSize: Int16
    @NSManaged public var product: Product?

}
