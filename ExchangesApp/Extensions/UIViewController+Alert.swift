//
//  UIViewController+Alert.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/11/25.
//

import UIKit

extension UIViewController {
  func presentAlert(for error: CurrencyError) {
    let alert = AlertFactory.makeErrorAlert(for: error)
    DispatchQueue.main.async {
      self.present(alert, animated: true)
    }
  }
}
