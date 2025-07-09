//
//  FavoriteStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import CoreData
import UIKit

class FavoriteStore {
  static let shared = FavoriteStore()
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

  func fetchFavorites() throws -> [String] {
    let req: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    let results = try context.fetch(req)
    return results.map { $0.code ?? "" }
  }

  func addFavorite(item: CurrencyItem) throws {
    let fav = FavoriteCurrency(context: context)
    fav.code = item.code
    fav.name = item.name
    fav.rate = item.rate
    try context.save()
  }

  func removeFavorite(code: String) throws {
    let req: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    req.predicate = NSPredicate(format: "code == %@", code)
    let results = try context.fetch(req)
    results.forEach { context.delete($0) }
    try context.save()
  }
}
