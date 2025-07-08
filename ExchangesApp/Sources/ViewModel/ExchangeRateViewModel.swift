//
//  ExchangeRateViewModel.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import Foundation

final class ExchangeRateViewModel {
    private let service = ExchangeRateService()

    var rates: [(String, Double)] = []
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    func fetchRates(base: String = "USD") {
        service.fetchRates(base: base) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let dict):
                    self?.rates = dict.map { ($0.key, $0.value) }.sorted { $0.0 < $1.0 }
                    self?.onUpdate?()
                case .failure:
                    self?.onError?("데이터를 불러올 수 없습니다")
                }
            }
        }
    }
}
