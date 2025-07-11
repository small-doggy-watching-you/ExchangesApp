//
//  FavoriteCurrency+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var rate: Double

}

extension FavoriteCurrency : Identifiable {

}
