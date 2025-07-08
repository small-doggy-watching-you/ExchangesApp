//
//  ExchangeRate.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

struct ExchangeRate: Codable {
  let timeLastUpdateUnix: Int
  let timeNextUpdateUnix: Int
  let timeLastUpdateUTC: String
  let timeNextUpdateUTC: String
  
  let rates: [String: Double]
  
  enum CodingKeys: String, CodingKey {
    case timeLastUpdateUnix = "time_last_update_unix"
    case timeNextUpdateUnix = "time_next_update_unix"
    case timeLastUpdateUTC = "time_last_update_utc"
    case timeNextUpdateUTC = "time_next_update_utc"
    case rates
  }
  
  var sortedRates: [(String, Double)] {
    rates.sorted { $0.key < $1.key }
  }
}
