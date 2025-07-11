//
//  CalculatorView.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/9/25.
//

import UIKit
import SnapKit

final class CalculatorView: UIView {

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "환율 계산기"
    label.font = .systemFont(ofSize: 30, weight: .bold)
    label.textColor = .label
    return label
  }()

  private let countryCodeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .label
    label.font = .systemFont(ofSize: 24, weight: .bold)
    return label
  }()

  private let countryNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 16)
    return label
  }()

  private lazy var labelStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [countryCodeLabel, countryNameLabel])
    stack.alignment = .center
    stack.axis = .vertical
    stack.spacing = 4
    return stack
  }()

  let amountTextField: UITextField = {
    let textField = UITextField()
    textField.textColor = .label
    textField.font = .systemFont(ofSize: 16)
    textField.borderStyle = .roundedRect
    textField.keyboardType = .decimalPad
    textField.textAlignment = .center
    textField.placeholder = "달러(USD)를 입력하세요"
    return textField
  }()

  let convertButton: UIButton = {
    let button = UIButton(type: .system)
    button.backgroundColor = .systemBlue
    button.setTitle("환율 계산", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
    button.layer.cornerRadius = 8
    return button
  }()

  let resultLabel: UILabel = {
    let label = UILabel()
    label.text = "계산 결과가 여기에 표시됩니다"
    label.textColor = .label
    label.font = .systemFont(ofSize: 20, weight: .medium)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configureUI() {
    backgroundColor = .systemBackground

    [titleLabel, labelStackView, amountTextField, convertButton, resultLabel].forEach {
      addSubview($0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
    }

    labelStackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32)
      $0.centerX.equalToSuperview()
    }

    amountTextField.snp.makeConstraints {
      $0.top.equalTo(labelStackView.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(44)
    }

    convertButton.snp.makeConstraints {
      $0.top.equalTo(amountTextField.snp.bottom).offset(24)
      $0.leading.trailing.equalToSuperview().inset(24)
      $0.height.equalTo(44)
    }

    resultLabel.snp.makeConstraints {
      $0.top.equalTo(convertButton.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview().inset(24)
    }
  }

  public func configureLabelStack(code: String, name: String) {
    countryCodeLabel.text = code
    countryNameLabel.text = name
  }
}
