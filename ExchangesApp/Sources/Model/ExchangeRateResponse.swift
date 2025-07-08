//
//  ExchangeRateResponse.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import Foundation

struct ExchangeRateResponse: Codable {
    let result: String
    let base_code: String
    let rates: [String: Double]
}
