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

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

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

  /// 버튼과 indexPath를 매핑해 버튼이 눌릴 때 어떤 셀인지 알 수 있게 합니다. 버튼 자체에는 indexPath 정보가 없으므로, 셀 생성 시점에 연결하고, 버튼을 key로 하여 indexPath를 찾습니다. (라고 합니다)
  /// 버튼은 약한 참조, indexPath는 강한 참조로 명시적으로 설정한 이유는, 버튼이 사라지면 자동으로 매핑도 사라지도록 만들어둔 것입니다.
  private var buttonIndexPathMap = NSMapTable<UIButton, NSIndexPath>(keyOptions: .weakMemory, valueOptions: .strongMemory)

  /// 맵 테이블에 이 버튼이 어떤 셀의 버튼인지 알 수 있도록 기억시켜 주는 함수.
  func assign(indexPath: IndexPath, to button: UIButton) {
    buttonIndexPathMap.setObject(indexPath as NSIndexPath, forKey: button)
  }

  /// 맵 테이블에서 버튼을 key로 하여 indexPath를 찾아 반환해 주는 함수.
  func indexPath(for button: UIButton) -> IndexPath? {
    return buttonIndexPathMap.object(forKey: button) as IndexPath?
  }
}
