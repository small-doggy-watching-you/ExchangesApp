//
//  CurrencyNameService.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/8/25.
//

import Foundation

class CurrencyNameService {
  
  var currencyNames: [String: String] = [:]
  
  /// 앱 번들에 포함된 CurrencyNames.json 파일을 읽어와, [String: String] 형태의 국가코드 국가명 딕셔너리로 디코딩하여 반환하는 함수.
  /// 결과는 Result 타입으로 성공 또는 실패 상태로 비동기적으로 반환합니다.
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
