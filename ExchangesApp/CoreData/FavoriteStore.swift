//
//  FavoriteStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import CoreData
import UIKit

final class FavoriteStore {

  private let context: NSManagedObjectContext

  init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Could not cast AppDelegate")
    }
    self.context = appDelegate.persistentContainer.viewContext
  }

  /// 즐겨찾기 목록을 [String] 형태로 반환 (통화 코드 리스트)
  func fetchFavorites() throws -> [String] {
    let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    let results = try context.fetch(request)
    return results.compactMap { $0.code }
  }

  /// 즐겨찾기 추가
  func addFavorite(item: CurrencyItem) throws {
    let fav = FavoriteCurrency(context: context)
    fav.code = item.code
    fav.name = item.name
    fav.rate = item.rate
    try context.save()
  }

  /// 즐겨찾기 제거 (통화 코드 기준)
  func removeFavorite(code: String) throws {
    let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    request.predicate = NSPredicate(format: "code == %@", code)

    let results = try context.fetch(request)
    results.forEach { context.delete($0) }

    try context.save()
  }
}
