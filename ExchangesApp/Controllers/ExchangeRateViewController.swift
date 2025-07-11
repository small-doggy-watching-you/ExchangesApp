//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

// mvvm에서 뷰는 로직이 없어야 되고, 뷰모델은 UIKit이 없어야 한다.
// loadView() 쓰는거 이상하다는 재성튜터님의 조언이 있었다고 한다. mvvm으로 바꿀 때 고치자

import UIKit

final class ExchangeRateViewController: UIViewController {
  
  private let exchangeRateView = ExchangeRateView()
  private let serviceManager = ExchangeRateServiceManager()
  
  private var allItems = [CurrencyItem]()               // 전체 환율 데이터
  private var isFiltering = false                       // 검색 중 여부 플래그
  private var filteredAllItems = [CurrencyItem]()       // 필터링된 전체 항목
  private var filteredFavoriteItems = [CurrencyItem]()  // 필터링된 즐겨찾기 항목
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("exchangeRateViewDidLoad")
    
    setupView()
    setupDelegates()
    
    loadCurrencyNames()
    fetchExchangeRates()
  }

  // MARK: - 뷰, 델리게이트 세팅
  
  private func setupView() {
    view.backgroundColor = .systemBackground
    view.addSubview(exchangeRateView)
    exchangeRateView.frame = view.bounds
  }

  private func setupDelegates() {
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.tableView.delegate = self
    exchangeRateView.searchBar.delegate = self
  }

  // MARK: - 데이터 로딩
  
  private func loadCurrencyNames() {
    serviceManager.loadCurrencyNames { [weak self] result in
      guard let self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success:
          break
        case .failure(let error):
          self.presentAlert(for: error)
        }
      }
    }
  }

  /// ServiceManager를 통해 API에서 환율을 받아오는 함수. 결과가 오면 allItems에 저장하고, 즐겨찾기 상태를 동기화합니다.
  private func fetchExchangeRates() {
    serviceManager.fetchExchangeRates { [weak self] result in
      guard let self else { return }
      DispatchQueue.main.async {
        switch result {
        case .success(let items):
          self.allItems = items
          self.syncFavorites()
        case .failure(let error):
          self.presentAlert(for: .decodingFailed(error)) // 실패 시 에러 알림 표시
        }
      }
    }
  }

  /// ServiceManager를 통해 모든 아이템의 isFavorite 정보를 최신화하고 테이블뷰를 갱신해 주는 함수.
  private func syncFavorites() {
    serviceManager.syncFavorites(to: &allItems)
    exchangeRateView.tableView.reloadData()
  }

  /// 별 버튼 클릭 시 호출되며, 해당 셀 항목의 isFavorite 값을 토글하고 CoreData에 반영하는 함수.
  /// 현재 검색중(필터링 중)이면 그 상태를 유지한 채로 갱신하며, 아니면 전체 테이블을 갱신합니다.
  @objc private func handleFavoriteTapped(_ sender: UIButton) {
    guard let indexPath = exchangeRateView.indexPath(for: sender),
          let item = item(at: indexPath),
          let index = allItems.firstIndex(where: { $0.code == item.code }) else { return }

    allItems[index].isFavorite.toggle()
    serviceManager.updateFavoriteStatus(for: allItems[index])

    isFiltering
      ? applyFilter(searchText: exchangeRateView.searchBar.text ?? "")
      : exchangeRateView.tableView.reloadData()
  }

  /// searchText에 맞게 allItems를 필터링해 즐겨찾기 리스트와 전체 리스트를 만들어 보여주는 함수.
  /// 필터링된 결과가 비었으면 emptyLabel을 보여주고, 테이블 갱신도 해 줍니다.
  private func applyFilter(searchText: String) {
    let trimmed = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    isFiltering = !trimmed.isEmpty

    filteredFavoriteItems = allItems.filter {
      $0.isFavorite && ($0.code.lowercased().contains(trimmed) || $0.name.lowercased().contains(trimmed))
    }

    filteredAllItems = allItems.filter {
      $0.code.lowercased().contains(trimmed) || $0.name.lowercased().contains(trimmed)
    }

    let baseItems = isFiltering ? filteredAllItems : allItems
    exchangeRateView.emptyLabel.isHidden = !baseItems.isEmpty
    exchangeRateView.tableView.reloadData()
  }

  /// 즐겨찾기 섹션과 전체 섹션에 맞는 항목 리스트를 반환하는 함수.
  /// 필터링 중(검색중)이면 필터링된 각각의 리스트를 반환합니다.
  private func sectionItems(for section: Int) -> [CurrencyItem] {
    let favorites = isFiltering ? filteredFavoriteItems : allItems.filter { $0.isFavorite }
    return section == 0 ? favorites : (isFiltering ? filteredAllItems : allItems)
  }

  /// 해당 IndexPath에 해당하는 아이템을 반환하는 함수.
  private func item(at indexPath: IndexPath) -> CurrencyItem? {
    let items = sectionItems(for: indexPath.section)
    return indexPath.row < items.count ? items[indexPath.row] : nil
  }
}

// MARK: - UITableViewDataSource

extension ExchangeRateViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sectionItems(for: section).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id, for: indexPath) as? ExchangeRateCell,
          let item = item(at: indexPath) else { return UITableViewCell() }

    cell.configureCell(with: item)
    cell.favoriteButton.addTarget(self, action: #selector(handleFavoriteTapped(_:)), for: .touchUpInside)
    exchangeRateView.assign(indexPath: indexPath, to: cell.favoriteButton)

    return cell
  }
}

// MARK: - UITableViewDelegate

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = item(at: indexPath) else { return }
    
    /// 환율 계산 화면으로 이동 시에 보여지는 백 버튼의 텍스트를 이전 화면의 타이틀라벨 텍스트로 설정합니다.
    let backItem = UIBarButtonItem()
    backItem.title = exchangeRateView.titleLabel.text ?? "뒤로"
    navigationItem.backBarButtonItem = backItem
    
    let vc = CalculatorViewController(item: item)
    navigationController?.pushViewController(vc, animated: true)
    navigationController?.setViewControllers([self, vc], animated: false)
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let hasFavorites = isFiltering ? !filteredFavoriteItems.isEmpty : !allItems.filter { $0.isFavorite }.isEmpty
    return section == 0 ? (hasFavorites ? "즐겨찾기" : nil) : (hasFavorites ? "전체" : nil)
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
}

// MARK: - UISearchBarDelegate

extension ExchangeRateViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    applyFilter(searchText: searchText)
  }
}
