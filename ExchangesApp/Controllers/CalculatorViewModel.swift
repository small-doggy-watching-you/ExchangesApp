//
//  CalculatorViewModel.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

// ViewModel은 생각하고 판단하는 것만. View에 보여줄 모든 정보를 담고 있어야 한다.

class CalculatorViewModel: ViewModelProtocol {
  
  private(set) var state: State
  
  var onStateChanged: ((State) -> Void)?
  
  init(currencyItem: CurrencyItem) {
    self.state = State(currencyItem: currencyItem)
  }
  
  func action(_ action: Action) {
    switch action {
    case .calculate(let number): // 숫자를 받아서
      state.result = number * state.currencyItem.rate
      onStateChanged?(state)
    }
  }
}

extension CalculatorViewModel {
  enum Action { // 이벤트 처리
    case calculate(Double)
  }
  
  struct State { // 상태 관리
    var result: Double = 0
    let currencyItem: CurrencyItem
  }
}
