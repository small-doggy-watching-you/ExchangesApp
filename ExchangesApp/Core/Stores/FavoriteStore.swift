//
//  FavoriteStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import CoreData
import UIKit

final class FavoriteStore {

  private let context: NSManagedObjectContext // CoreData에서 DB처럼 쓰는 작업공간. CRUD를 여기서 한다.

  init() { // AppDelegate에서 설정된 것을 사용하기 위한 초기화.
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Could not cast AppDelegate")
    }
    self.context = appDelegate.persistentContainer.viewContext
  }

  /// 즐겨찾기 목록 전체를 요청해 가져오고, 그 중 국가코드만 꺼내 [String] 형태로 반환하는 함수.
  func fetchFavorites() throws -> [String] {
    let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    let results = try context.fetch(request)
    return results.compactMap { $0.code }
  }

  /// 새로운 엔티티 인스턴스를 생성해 CurrencyItem 내용으로 값을 채운 후 CoreData에 저장하는 함수.
  func addFavorite(item: CurrencyItem) throws {
    let fav = FavoriteCurrency(context: context)
    fav.code = item.code
    fav.name = item.name
    fav.rate = item.rate
    try context.save()
  }

  /// 즐겨찾기 목록 전체를 요청해 가져오고, 특정 code와 일치하는 데이터만 골라서 삭제한 후 CoreData에 저장하는 함수.
  func removeFavorite(code: String) throws {
    let request: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    request.predicate = NSPredicate(format: "code == %@", code)

    let results = try context.fetch(request)
    results.forEach { context.delete($0) }

    try context.save()
  }
}
