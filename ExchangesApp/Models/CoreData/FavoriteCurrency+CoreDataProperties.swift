//
//  FavoriteCurrency+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by Yoon on 7/11/25.
//
//

import CoreData
import Foundation

public extension FavoriteCurrency {
    @nonobjc class func fetchRequest() -> NSFetchRequest<FavoriteCurrency> {
        return NSFetchRequest<FavoriteCurrency>(entityName: "FavoriteCurrency")
    }

    @NSManaged var code: String?
}

extension FavoriteCurrency: Identifiable {}
