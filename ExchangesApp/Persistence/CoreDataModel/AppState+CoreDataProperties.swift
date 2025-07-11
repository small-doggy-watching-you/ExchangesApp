//
//  AppState+CoreDataProperties.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//
//

import Foundation
import CoreData


extension AppState {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppState> {
        return NSFetchRequest<AppState>(entityName: "AppState")
    }

    @NSManaged public var screen: String
    @NSManaged public var code: String?
    @NSManaged public var name: String?
    @NSManaged public var rate: Double

}

extension AppState : Identifiable {

}
