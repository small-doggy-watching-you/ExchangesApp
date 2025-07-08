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
    return label
  }()
  
  private let countryNameLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .systemBackground
    label.textColor = .label
    return label
  }()
  
  private let rateLabel: UILabel = {
    let label = UILabel()
    label.backgroundColor = .systemBackground
    label.textColor = .label
    return label
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
    [countryCodeLabel, countryNameLabel, rateLabel].forEach {
      contentView.addSubview($0)
    }
    
    countryCodeLabel.snp.makeConstraints {
      $0.bottom.equalTo(contentView.snp.centerY).inset(4)
      $0.leading.equalToSuperview().inset(20)
    }
    
    countryNameLabel.snp.makeConstraints {
      $0.top.equalTo(contentView.snp.centerY).inset(4)
      $0.leading.equalToSuperview().inset(20)
    }
    
    rateLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(20)
    }
  }
  
  public func configureCell(code: String, rate: Double) {
    countryCodeLabel.text = code
    countryNameLabel.text = "일단아무거나"
    rateLabel.text = String(format: "%.4f", rate)
  }
  
}
