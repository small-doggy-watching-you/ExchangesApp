//
//  CalculatorViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import UIKit

final class CalculatorViewController: UIViewController {

  private let calculatorView = CalculatorView()
  private let currencyItem: CurrencyItem

  init(item: CurrencyItem) {
    self.currencyItem = item
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    print("calculatorViewDidLoad")
    
    setupView()
    setupActions()
    configureView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    if self.isMovingFromParent { // 네비게이션 스택에서 pop되어 사라지고 있는 중일 때
      try? AppStateStore().saveLastScreenState(screen: "list", item: nil)
    }
  }

  private func setupView() {
    view.backgroundColor = .systemBackground
    view.addSubview(calculatorView)
    calculatorView.frame = view.bounds
  }

  private func setupActions() {
    calculatorView.convertButton.addTarget(self, action: #selector(handleCalculate), for: .touchUpInside)
  }

  private func configureView() {
    calculatorView.configureLabelStack(code: currencyItem.code, name: currencyItem.name)
  }

  @objc private func handleCalculate() {
    guard let input = calculatorView.amountTextField.text,
          let number = Double(input) else {
      calculatorView.resultLabel.text = "올바른 숫자를 입력하세요."
      return
    }

    let result = number * currencyItem.rate
    calculatorView.resultLabel.text = String(format: "%.2f", result)
  }
}
