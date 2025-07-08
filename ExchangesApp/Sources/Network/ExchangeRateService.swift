//
//  ExchangeRateService.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import Foundation

final class ExchangeRateService {
    func fetchRates(base: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        let urlString = "https://open.er-api.com/v6/latest/\(base)"
        print("호출 URL : \(urlString)")
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: 0)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                completion(.success(decoded.rates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
