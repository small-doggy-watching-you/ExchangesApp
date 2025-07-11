//
//  CurrencyStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

import CoreData
import UIKit

class CurrencyStore {
  static let shared = CurrencyStore()
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  /// 전체 환율 데이터를 CoreData에 저장하는 함수. 기존 내용을 삭제하고 저장한다.
  func saveAllCurrencies(_ items: [CurrencyItem]) throws {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = StoredCurrency.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    try context.execute(deleteRequest)
    
    for item in items {
      let stored = StoredCurrency(context: context)
      stored.code = item.code
      stored.name = item.name
      stored.rate = item.rate
      stored.updatedAt = Date()
    }
    
    try context.save()
  }
  
  /// CoreData에 저장된 전체 환율 목록을 요청해 불러오는 함수.
  func fetchAllCurrencies() throws -> [StoredCurrency] {
    let request: NSFetchRequest<StoredCurrency> = StoredCurrency.fetchRequest()
    return try context.fetch(request)
  }
  
  /// 저장된 목록을 불러와 환율 비교를 위해 사전 형태로 반환하는 함수.
  func fetchRatesAsDictionary() throws -> [String: Double] {
    let currencies = try fetchAllCurrencies()
    return Dictionary(uniqueKeysWithValues: currencies.compactMap {
      guard let code = $0.code else { return nil }
      return (code, $0.rate)
    })
  }
}
