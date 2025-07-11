//
//  ExchangeRateViewModel.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

// ViewModel은 생각하고 판단하는 것만. View에 보여줄 모든 정보를 담고 있어야 한다.

import Foundation

final class ExchangeRateViewModel: ViewModelProtocol {
  
  struct State {
    var items: [CurrencyItem] = []
    var isFiltering: Bool = false
    var loadingState: LoadingState = .idle
  }
  
  enum LoadingState {
    case idle
    case loading
    case loaded
    case error(CurrencyError)
  }
  
  enum Action {
    case onAppear
    case toggleFavorite(code: String)
    case search(query: String)
  }
  
  private(set) var state = State() {
    didSet { onStateChanged?(state) }
  }
  
  var onStateChanged: ((State) -> Void)?
  private let serviceManager = ExchangeRateServiceManager()
  private var currentQuery: String = ""
  
  var filteredItems: [CurrencyItem] {
    guard state.isFiltering else { return [] }
    let trimmed = currentQuery.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    return state.items.filter {
      $0.code.lowercased().contains(trimmed) || $0.name.lowercased().contains(trimmed)
    }
  }
  
  func action(_ action: Action) {
    switch action {
    case .onAppear:
      loadData()
    case .toggleFavorite(let code):
      toggleFavorite(code: code)
    case .search(let query):
      applyFilter(query)
    }
  }
  
  
  private func loadData() {
    state.loadingState = .loading
    serviceManager.loadCurrencyNames { [weak self] result in
      guard let self else { return }
      if case let .failure(error) = result {
        self.state.loadingState = .error(error)
        return
      }
      self.fetchRates()
    }
  }
  
  private func fetchRates() {
    serviceManager.fetchExchangeRates { [weak self] result in
      guard let self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(var items):
          self.serviceManager.syncFavorites(to: &items)
          self.state.items = items
          self.state.loadingState = .loaded
        case .failure(let error):
          self.state.loadingState = .error(error)
        }
      }
    }
  }
  
  private func toggleFavorite(code: String) {
    var items = state.items
    guard let index = items.firstIndex(where: { $0.code == code }) else { return }
    items[index].isFavorite.toggle()
    serviceManager.updateFavoriteStatus(for: items[index])
    state.items = items
    applyFilter(currentQuery)
  }
  
  private func applyFilter(_ query: String) {
    currentQuery = query
    state.isFiltering = !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }
}
