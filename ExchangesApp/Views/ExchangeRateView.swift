//
//  ExchangeRateView.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

import UIKit
import SnapKit

final class ExchangeRateView: UIView {

  // MARK: - UI Components

  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "환율 정보"
    label.textColor = .label
    label.font = .systemFont(ofSize: 30, weight: .bold)
    return label
  }()

  let searchBar: UISearchBar = {
    let searchBar = UISearchBar()
    searchBar.placeholder = "통화 검색"
    return searchBar
  }()

  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.id)
    return tableView
  }()

  let emptyLabel: UILabel = {
    let label = UILabel()
    label.text = "검색 결과 없음"
    label.textColor = .secondaryLabel
    label.font = .systemFont(ofSize: 17)
    label.textAlignment = .center
    label.isHidden = true
    return label
  }()

  // MARK: - Init

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - UI Setup

  private func setupUI() {
    backgroundColor = .systemBackground

    [titleLabel, searchBar, tableView, emptyLabel].forEach {
      addSubview($0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(16)
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

    emptyLabel.snp.makeConstraints {
      $0.center.equalTo(tableView)
    }
  }

  // MARK: - Button IndexPath Tracking

  private var buttonIndexPathMap = NSMapTable<UIButton, NSIndexPath>(keyOptions: .weakMemory, valueOptions: .strongMemory)

  func assign(indexPath: IndexPath, to button: UIButton) {
    buttonIndexPathMap.setObject(indexPath as NSIndexPath, forKey: button)
  }

  func indexPath(for button: UIButton) -> IndexPath? {
    return buttonIndexPathMap.object(forKey: button) as IndexPath?
  }
}
