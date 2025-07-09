//
//  ExchangeRateCell.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {
  
  static let id = "ExchangeRateCell"
  
  private let countryCodeLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .systemBackground
    label.textColor = .label
    label.font = .systemFont(ofSize: 16, weight: .medium)
    return label
  }()
  
  private let countryNameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .systemBackground
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 14)
    return label
  }()
  
  private lazy var labelStackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [countryCodeLabel, countryNameLabel])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.spacing = 4
    return stack
  }()
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .systemBackground
    label.textColor = .label
    label.font = .systemFont(ofSize: 16)
    label.textAlignment = .right
    return label
  }()
  
  let favoriteButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(UIImage(systemName: "star"), for: .normal)
    button.tintColor = .systemYellow
    return button
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    contentView.backgroundColor = .systemBackground
    [labelStackView, rateLabel, favoriteButton].forEach {
      contentView.addSubview($0)
    }
    
    labelStackView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().inset(16)
    }
    
    rateLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).inset(16)
      $0.trailing.equalTo(favoriteButton.snp.leading).offset(-16)
      $0.width.equalTo(120)
    }
    
    favoriteButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(16)
    }
  }
  
  public func configureCell(code: String, name: String, rate: Double) {
    countryCodeLabel.text = code
    countryNameLabel.text = name
    rateLabel.text = String(format: "%.4f", rate)
  }
  
}
