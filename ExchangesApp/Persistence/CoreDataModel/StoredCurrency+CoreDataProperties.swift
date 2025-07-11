//
//  StoredCurrency+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//
//

import Foundation
import CoreData


extension StoredCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredCurrency> {
        return NSFetchRequest<StoredCurrency>(entityName: "StoredCurrency")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var rate: Double
    @NSManaged public var updatedAt: Date?

}

extension StoredCurrency : Identifiable {

}
