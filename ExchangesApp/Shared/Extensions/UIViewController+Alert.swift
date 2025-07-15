//
//  UIViewController+Alert.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

import UIKit

extension UIViewController {
  /// CurrencyError에 해당하는 에러에 대한 Alert을 간단하게 호출할 수 있도록 하는 함수.
  func presentAlert(for error: CurrencyError) {
    let alert = AlertFactory.makeErrorAlert(for: error)
    DispatchQueue.main.async {
      self.present(alert, animated: true)
    }
  }
}
