//
//  CurrencySnapshot+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//
//

import CoreData
import Foundation

public extension CurrencySnapshot {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CurrencySnapshot> {
        return NSFetchRequest<CurrencySnapshot>(entityName: "CurrencySnapshot")
    }

    @NSManaged var baseCode: String?
    @NSManaged var ratesJSON: String?
    @NSManaged var dateKey: String?
    @NSManaged var timestamp: Date?
}

extension CurrencySnapshot: Identifiable {}
