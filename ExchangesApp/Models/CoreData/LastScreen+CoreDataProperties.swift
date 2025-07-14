//
//  LastScreen+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by Yoon on 7/12/25.
//
//

import CoreData
import Foundation

public extension LastScreen {
    @nonobjc class func fetchRequest() -> NSFetchRequest<LastScreen> {
        return NSFetchRequest<LastScreen>(entityName: "LastScreen")
    }

    @NSManaged var screenType: String?
    @NSManaged var currencyCode: String?
}

extension LastScreen: Identifiable {}
