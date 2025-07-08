//
//  DataService.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import Foundation
import Alamofire

class ExchangeRateService {
  private let baseURLString = "https://open.er-api.com/v6/latest/USD"

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
