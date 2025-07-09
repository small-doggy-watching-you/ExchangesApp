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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setup() {
    backgroundColor = .systemBackground
    
    [titleLabel].forEach {
      addSubview($0)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
    }
  }
}
