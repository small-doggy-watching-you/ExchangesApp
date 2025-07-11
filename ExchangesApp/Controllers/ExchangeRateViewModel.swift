//
//  ExchangeRateViewModel.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

// ViewModel은 생각하고 판단하는 것만. View에 보여줄 모든 정보를 담고 있어야 한다.

class ExchangeRateViewModel: ViewModelProtocol {
  
  private(set) var state: State
  
  init() {
    
  }
  
  func action(_ action: Action) {
    <#code#>
  }
  
  
  
  
}

extension ExchangeRateViewModel {
  enum Action {
    
  }
  
  struct State {
    
  }
}
