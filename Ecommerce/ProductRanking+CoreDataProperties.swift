//
//  ProductRanking+CoreDataProperties.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import Foundation
import CoreData


extension ProductRanking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductRanking> {
        return NSFetchRequest<ProductRanking>(entityName: "ProductRanking")
    }

    @NSManaged public var prodID: Int16
    @NSManaged public var viewCount: Int64
    @NSManaged public var ranking: Ranking?

}
