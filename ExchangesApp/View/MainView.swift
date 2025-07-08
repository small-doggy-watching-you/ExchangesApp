//
//  MainView.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import UIKit
import SnapKit

final class MainView: UIView {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "환율 정보"
    label.textColor = .label
    label.font = .systemFont(ofSize: 30, weight: .bold)
    return label
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .systemBackground
    tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.id)
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    backgroundColor = .systemBackground
    
    [titleLabel, tableView].forEach {
      addSubview( $0 )
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview()
    }
  }
}
