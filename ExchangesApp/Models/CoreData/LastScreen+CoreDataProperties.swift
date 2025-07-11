//
//  LastScreen+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by Yoon on 7/12/25.
//
//

import Foundation
import CoreData


extension LastScreen {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LastScreen> {
        return NSFetchRequest<LastScreen>(entityName: "LastScreen")
    }

    @NSManaged public var screenType: String?
    @NSManaged public var currencyCode: String?

}

extension LastScreen : Identifiable {

}
