//
//  ExchangeRateService.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import Foundation
import Alamofire

class ExchangeRateService {
  
  private let baseURLString = "https://open.er-api.com/v6/latest/USD"

  /// [ExchangeRate] 환율 데이터를 API로부터 받아와, `rates` 딕셔너리를 알파벳 순으로 정렬된 배열로 가공하여 반환하는 함수.
  /// 결과는 Result 타입을 통해 성공 또는 실패 상태로 비동기적으로 반환합니다.
  func fetchSortedRates(completion: @escaping (Result<[(String, Double)], AFError>) -> Void) {
    guard let url = URL(string: baseURLString) else {
      completion(.failure(AFError.invalidURL(url: "잘못된 URL")))
      return
    }

    AF.request(url).responseDecodable(of: ExchangeRate.self) { response in
      switch response.result {
      case .success(let data):
        let sorted = data.rates.sorted { $0.key < $1.key }
        completion(.success(sorted))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}
