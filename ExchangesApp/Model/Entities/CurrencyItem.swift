//
//  CurrencyItem.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

enum RateTrend {
  case up, down, same
}

struct CurrencyItem {
  let code: String
  let name: String
  let rate: Double
  var isFavorite: Bool = false
  var trend: RateTrend? = nil
}
