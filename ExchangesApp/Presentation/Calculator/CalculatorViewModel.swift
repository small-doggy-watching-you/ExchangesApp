//
//  CalculatorViewModel.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

// ViewModel은 생각하고 판단하는 것만. View에 보여줄 모든 정보를 담고 있어야 한다.

class CalculatorViewModel: ViewModelProtocol {
  
  private(set) var state: State {
    didSet { onStateChanged?(state) }
  }
  
  var onStateChanged: ((State) -> Void)?
  
  init(currencyItem: CurrencyItem) {
    self.state = State(currencyItem: currencyItem)
  }
  
  func action(_ action: Action) {
    switch action {
    case .calculate(let number): // 숫자를 받아서
      state.input = number
    }
  }
}

extension CalculatorViewModel {
  enum Action { // 이벤트 처리
    case calculate(Double)
  }
  
  struct State { // 상태 관리
    let currencyItem: CurrencyItem
    var input: Double = 0
    
    var result: Double {
      input * currencyItem.rate
    }
  }
}
