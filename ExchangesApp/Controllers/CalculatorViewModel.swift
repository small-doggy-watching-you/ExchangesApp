//
//  CalculatorViewModel.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

class CalculatorViewModel: ViewModelProtocol {
  
  private(set) var state: State
  
  var onStateChanged: ((State) -> Void)?
  
  init(currencyItem: CurrencyItem) {
    self.state = State(currencyItem: currencyItem)
  }
  
  func action(_ action: Action) {
    switch action {
    case .calculate(let number):
      state.result = number * state.currencyItem.rate
      onStateChanged?(state)
    }
  }
}

extension CalculatorViewModel {
  enum Action {
    case calculate(Double)
  }
  
  struct State {
    var result: Double = 0
    let currencyItem: CurrencyItem
  }
}
