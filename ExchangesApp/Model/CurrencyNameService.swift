//
//  CurrencyNameService.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/8/25.
//

import Foundation

class CurrencyNameService {
  
  func loadCurrencyNames(completion: @escaping (Result<[String: String], CurrencyError>) -> Void) {
    guard let path = Bundle.main.path(forResource: "CurrencyNames", ofType: "json") else {
      print("JSON file not found")
      completion(.failure(.fileNotFound))
      return
    }
    
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path))
      let currencyNames = try JSONDecoder().decode([String: String].self, from: data)
      completion(.success(currencyNames))
    } catch {
      print("JSON parsing error : \(error)")
      completion(.failure(.decodingFailed(error)))
    }
  }
}
