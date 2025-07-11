//
//  FavoriteCurrency+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//
//

import Foundation
import CoreData


extension FavoriteCurrency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged public var code: String?

}

extension FavoriteCurrency : Identifiable {

}
