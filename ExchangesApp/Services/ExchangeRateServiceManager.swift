//
//  ExchangeRateServiceManager.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

import Foundation

final class ExchangeRateServiceManager {
  
  private let exchangeRateService = ExchangeRateService()
  private let currencyNameService = CurrencyNameService()
  private let currencyStore = CurrencyStore()
  private let favoriteStore = FavoriteStore()
  
  /// JSON을 통해 국가코드-국가명 데이터 [코드:이름] 딕셔너리를 가져와 저장하는 함수.
  func loadCurrencyNames(completion: @escaping (Result<Void, CurrencyError>) -> Void) {
    currencyNameService.loadCurrencyNames { result in
      switch result {
      case .success(let names):
        self.currencyNameService.currencyNames = names
        completion(.success(()))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  /// API를 통해 환율 데이터를 받아오고 CurrencyItem 배열로 변환 후 즐겨찾기 반영하는 함수.
  func fetchExchangeRates(completion: @escaping (Result<[CurrencyItem], CurrencyError>) -> Void) {
    exchangeRateService.fetchSortedRates { [weak self] result in
      guard let self = self else { return }
      
      switch result {
      case .success(let sortedRates):
        do {
          var previousRates = try self.currencyStore.fetchRatesDictionary()
          let items = sortedRates.map { code, rate -> CurrencyItem in
            let name = self.currencyNameService.currencyNames[code] ?? "알 수 없음"
            
            // !환율 변동 테스트를 위한 코드로, 테스트 중이 아닌 경우 주석처리하시오!
//            previousRates[code] = previousRates[code]! * Double.random(in: 0.95...1.05)
            
            let trend = self.trend(from: previousRates[code], to: rate)
            return CurrencyItem(code: code, name: name, rate: rate, isFavorite: false, trend: trend)
          }
          try self.currencyStore.saveAllCurrencies(items)
          completion(.success(items))
        } catch {
          completion(.failure(.networkFailed(error)))
        }
        
      case .failure(let afError):
        completion(.failure(.networkFailed(afError)))
      }
    }
  }
  
  /// 과거 환율과 현재 환율을 비교해 등락여부를 반환하는 함수.
  private func trend(from old: Double?, to new: Double) -> RateTrend? {
    guard let old = old else { return nil } // 과거 환율이 존재하지 않는 경우 trend 산출 불가
    if new > old {
      return .up
    } else if new < old {
      return .down
    } else {
      return .same
    }
  }
  
  /// CoreData에서 즐겨찾기 리스트를 가져와 allItems에 isFavorite 값을 반영하는 함수.
  func syncFavorites(to items: inout [CurrencyItem]) {
    do {
      let favoriteCodes = try favoriteStore.fetchFavorites()
      items = items.map { item in
        var updated = item
        updated.isFavorite = favoriteCodes.contains(item.code)
        return updated
      }
    } catch {
      print("즐겨찾기 동기화 실패: \(error)")
    }
  }
  
  /// CoreData에 아이템의 즐겨찾기 상태를 반영하는 함수.
  func updateFavoriteStatus(for item: CurrencyItem) {
    do {
      if item.isFavorite {
        try favoriteStore.addFavorite(item: item)
      } else {
        try favoriteStore.removeFavorite(code: item.code)
      }
    } catch {
      print("즐겨찾기 저장 실패: \(error)")
    }
  }
}
