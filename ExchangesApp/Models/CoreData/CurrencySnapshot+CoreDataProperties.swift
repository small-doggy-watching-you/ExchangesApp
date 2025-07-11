//
//  CurrencySnapshot+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//
//

import Foundation
import CoreData


extension CurrencySnapshot {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CurrencySnapshot> {
        return NSFetchRequest<CurrencySnapshot>(entityName: "CurrencySnapshot")
    }

    @NSManaged public var baseCode: String?
    @NSManaged public var ratesJSON: String?
    @NSManaged public var dateKey: String?
    @NSManaged public var timestamp: Date?

}

extension CurrencySnapshot : Identifiable {

}
