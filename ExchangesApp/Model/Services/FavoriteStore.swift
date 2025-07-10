//
//  FavoriteStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import CoreData
import UIKit

/// 앱에서 사용자가 즐겨찾기로 저장한 환율 정보를 관리하는 CoreData 저장소 클래스.
class FavoriteStore {

  static let shared = FavoriteStore() // FavoriteStore의 싱글톤 인스턴스.
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext // CoreData에서 데이터 저장/조회 등의 작업을 수행하기 위한 context 객체.

  /// CoreData에 저장된 즐겨찾기 통화 정보를 불러와 각 통화의 코드만 [String] 형태로 반환하는 함수.
  func fetchFavorites() throws -> [String] {
    let req: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest() // FavoriteCurrency 엔티티를 가져오기 위한 요청 객체.
    let results = try context.fetch(req) // 요청을 실행하여 CoreData에서 데이터를 실제로 가져옵니다.
    return results.map { $0.code ?? "" } // 각 결과 객체에서 code 값을 추출하고, nil이면 빈 문자열로 대체합니다.
  }
  
  /// 전달받은 CurrencyItem의 코드, 이름, 환율 정보를 기반으로 새로운 즐겨찾기 항목을 생성하여 CoreData에 저장하는 함수.
  func addFavorite(item: CurrencyItem) throws {
    let fav = FavoriteCurrency(context: context)
    fav.code = item.code
    fav.name = item.name
    fav.rate = item.rate
    try context.save()
  }

  /// 지정된 통화 코드에 해당하는 즐겨찾기 항목을 CoreData에서 찾아 삭제하는 함수.
  func removeFavorite(code: String) throws {
    let req: NSFetchRequest<FavoriteCurrency> = FavoriteCurrency.fetchRequest()
    req.predicate = NSPredicate(format: "code == %@", code)
    
    let results = try context.fetch(req)
    results.forEach { context.delete($0) } // 가져온 모든 일치 항목을 삭제합니다.
    try context.save()
  }
}
