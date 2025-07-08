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
  
  func fetchData(completion: @escaping (Result<ExchangeRate, AFError>) -> Void) {
    guard let url = URL(string: baseURLString) else {
      completion(.failure(AFError.invalidURL(url: "잘못된 URL")))
      return
    }
    
    AF.request(url).responseDecodable(of: ExchangeRate.self) { response in completion(response.result)
    }
  }
}
