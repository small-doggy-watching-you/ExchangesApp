//
//  AlertFactory.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/8/25.
//

import UIKit

struct AlertFactory {
  
  static func makeErrorAlert(for error: CurrencyError) -> UIAlertController {
    let alert = UIAlertController(title: error.alertTitle, message: error.alertMessage, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "확인", style: .default))
    return alert
  }
  
  static func makeSimpleAlert(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
    return alert
  }
}
