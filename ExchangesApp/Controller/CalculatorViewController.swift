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
  
  /// 생성 시에 뷰에 올라가는 UI 컴포넌트의 텍스트를 지정해줌으로써 뷰가 로드되기 전에 데이터 주입을 완료함.
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
  
  /// amountTextField에 입력되어 있는 텍스트를 Double로 변환하고, 환율을 곱해서 resultLabel의 텍스트로 소숫점 둘째 자리까지만 표시하도록 넣어주는 함수.
  @objc func handleCalculate() {
    guard let input = calculatorView.amountTextField.text, let number = Double(input) else {
      calculatorView.resultLabel.text = "올바른 숫자를 입력하세요."
      return
    }
    
    let result = number * (self.rate ?? 0)
    calculatorView.resultLabel.text = String(format: "%.2f", result)
  }
}
