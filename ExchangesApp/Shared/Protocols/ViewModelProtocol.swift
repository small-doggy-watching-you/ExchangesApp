//
//  ViewModelProtocol.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

protocol ViewModelProtocol { // 뷰 모델에 규격을 정하는 것
  associatedtype Action // 뷰모델에서 처리할 수 있는 액션
  associatedtype State // 데이터 등
  
  func action(_ action: Action)
  
  var state: State { get } // read only
}
