//
//  Ranking+CoreDataProperties.swift
//  Ecommerce
//
//  Created by Neethu Sadasivan on 14/11/17.
//  Copyright © 2017 Neethu Sadasivan. All rights reserved.
//

import Foundation
import CoreData


extension Ranking {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ranking> {
        return NSFetchRequest<Ranking>(entityName: "Ranking")
    }

    @NSManaged public var rankingName: String?
    @NSManaged public var productrankings: NSSet?

}

// MARK: Generated accessors for productrankings
extension Ranking {

    @objc(addProductrankingsObject:)
    @NSManaged public func addToProductrankings(_ value: ProductRanking)

    @objc(removeProductrankingsObject:)
    @NSManaged public func removeFromProductrankings(_ value: ProductRanking)

    @objc(addProductrankings:)
    @NSManaged public func addToProductrankings(_ values: NSSet)

    @objc(removeProductrankings:)
    @NSManaged public func removeFromProductrankings(_ values: NSSet)

}
