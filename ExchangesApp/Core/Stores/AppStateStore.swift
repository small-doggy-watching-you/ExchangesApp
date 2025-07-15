//
//  AppStateStore.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

import CoreData
import UIKit

final class AppStateStore {
  
  private let context: NSManagedObjectContext
  
  init() {
    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
      fatalError("Could not cast AppDelegate")
    }
    self.context = appDelegate.persistentContainer.viewContext
  }
  
  /// CoreData에 마지막 화면 상태를 요청해 가져오고, screen이 list일 경우엔 그것만 돌려주고, calculator일 경우엔 item도 반환하는 함수.
  func fetchLastScreenState() throws -> (screen: String, item: CurrencyItem?) {
    let request: NSFetchRequest<AppState> = AppState.fetchRequest()
    let result = try context.fetch(request)

    var screen = "list"
    var item: CurrencyItem? = nil

    if let state = result.first {
      let savedScreen = state.screen
      screen = savedScreen

      if savedScreen == "calculator",
         let code = state.code,
         let name = state.name {
        item = CurrencyItem(code: code, name: name, rate: state.rate, isFavorite: false)
      }
    }

    return (screen, item)
  }
  
  /// 기존 마지막 화면상태 데이터를 요청해 가져와 모두 삭제해버리고, 매개변수로 받아온 화면상태 아이템으로 엔티티를 꾸려 저장하는 함수.
  func saveLastScreenState(screen: String, item: CurrencyItem?) throws {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = AppState.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    try context.execute(deleteRequest)
    
    let state = AppState(context: context)
    state.screen = screen
    state.code = item?.code
    state.name = item?.name
    state.rate = item?.rate ?? 0
    try context.save()
  }
}
