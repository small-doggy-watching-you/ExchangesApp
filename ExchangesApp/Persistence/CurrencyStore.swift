//
//  CurrencyStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

import CoreData
import UIKit

final class CurrencyStore {

  private let context: NSManagedObjectContext

  init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Could not cast AppDelegate")
    }
    self.context = appDelegate.persistentContainer.viewContext
  }

  /// 환율 데이터를 요청해 가져와 국가코드-환율을 딕셔너리로 반환하는 함수.
  func fetchRatesDictionary() throws -> [String: Double] {
    let request: NSFetchRequest<StoredCurrency> = StoredCurrency.fetchRequest()
    let currencies = try context.fetch(request)

    return Dictionary(uniqueKeysWithValues: currencies.compactMap {
      guard let code = $0.code else { return nil }
      return (code, $0.rate)
    })
  }

  /// 기존 환율 데이터를 요청해 가져온 뒤 모두 삭제해버리고, 새로 매개변수로 받아온 환율 아이템들로 엔티티들을 꾸려 저장하는 함수.
  func saveAllCurrencies(_ items: [CurrencyItem]) throws {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = StoredCurrency.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    try context.execute(deleteRequest)

    for item in items {
      let entity = StoredCurrency(context: context)
      entity.code = item.code
      entity.name = item.name
      entity.rate = item.rate
      entity.updatedAt = Date()
    }

    try context.save()
  }

  /// CoreData에 저장된 모든 환율 항목 조회
  func fetchAllStoredCurrencies() throws -> [StoredCurrency] {
    let request: NSFetchRequest<StoredCurrency> = StoredCurrency.fetchRequest()
    return try context.fetch(request)
  }
}
