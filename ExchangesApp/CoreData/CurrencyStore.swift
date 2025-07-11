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

  /// 저장된 환율을 딕셔너리로 반환
  func fetchRatesDictionary() throws -> [String: Double] {
    let request: NSFetchRequest<StoredCurrency> = StoredCurrency.fetchRequest()
    let currencies = try context.fetch(request)

    return Dictionary(uniqueKeysWithValues: currencies.compactMap {
      guard let code = $0.code else { return nil }
      return (code, $0.rate)
    })
  }

  /// 전체 환율 데이터를 기존 데이터 제거 후 저장
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
