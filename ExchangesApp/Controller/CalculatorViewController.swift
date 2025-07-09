//
//  CalculatorViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import UIKit

class CalculatorViewController: UIViewController {
  
  private let calculatorView = CalculatorView()
  private var currency: String?
  private var countryName: String?
  private var rate: Double?
  
  init(_ code: String, _ name: String, _ rate: Double) {
    calculatorView.countryCodeLabel.text = code
    calculatorView.countryNameLabel.text = name
    self.currency = code
    self.countryName = name
    self.rate = rate
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    self.view = calculatorView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("calculatorViewDidLoad")
  }
}

extension CalculatorViewController: UITextFieldDelegate {
  
}
