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
    
    calculatorView.convertButton.addTarget(self, action: #selector(handleCalculate), for: .touchUpInside)
  }
  
  @objc func handleCalculate() {
    guard let input = calculatorView.amountTextField.text, let number = Double(input) else {
      calculatorView.resultLabel.text = "올바른 숫자를 입력하세요."
      return
    }
    
    let result = number * (self.rate ?? 0)
    calculatorView.resultLabel.text = String(format: "%.2f", result)
  }
}
