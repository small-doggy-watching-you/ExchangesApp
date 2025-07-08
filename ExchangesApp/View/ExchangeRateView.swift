//
//  ExchangeRateView.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import UIKit
import SnapKit

final class ExchangeRateView: UIView {
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "환율 정보"
    label.textColor = .label
    label.font = .systemFont(ofSize: 30, weight: .bold)
    return label
  }()
  
  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.searchTextField.backgroundColor = .systemBackground
    return searchBar
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .systemBackground
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.id)
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
    
    [titleLabel, searchBar, tableView].forEach {
      addSubview( $0 )
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
    }
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview()
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalToSuperview()
    }
  }
}
