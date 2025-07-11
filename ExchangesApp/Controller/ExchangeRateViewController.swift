//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

// mvvm에서 뷰는 로직이 없어야 되고, 뷰모델은 UIKit이 없어야 한다.
// loadView() 쓰는거 이상하다는 재성튜터님의 조언이 있었다고 한다. mvvm으로 바꿀 때 고치자

import UIKit

class ExchangeRateViewController: UIViewController {
  
  private let exchangeRateView = ExchangeRateView()
  private let exchangeRateService = ExchangeRateService()
  private let currencyNameService = CurrencyNameService()
  
  private var allItems = [CurrencyItem]()               // 전체 환율 데이터
  private var favoriteItems: [CurrencyItem] {           // 현재 즐겨찾기로 지정된 항목만 필터링
    allItems.filter { $0.isFavorite }
  }
  private var isFiltering = false                       // 검색 중 여부 플래그
  private var filteredAllItems = [CurrencyItem]()       // 필터링된 전체 항목
  private var filteredFavoriteItems = [CurrencyItem]()  // 필터링된 즐겨찾기 항목
  
  override func loadView() {
    self.view = exchangeRateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("exchangeRateViewDidLoad")
    
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.tableView.delegate = self
    exchangeRateView.searchBar.delegate = self
    
    loadCurrencyNames()
    fetchExchangeRate()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    navigationItem.backBarButtonItem = {
      let item = UIBarButtonItem()
      item.title = exchangeRateView.titleLabel.text
      return item
    }()
  }
  
  /// JSON을 통해 국가코드 국가명 데이터 [코드:이름] 딕셔너리를 가져와 저장하는 함수.
  private func loadCurrencyNames() {
    currencyNameService.loadCurrencyNames { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let names):
        DispatchQueue.main.async {
          self.currencyNameService.currencyNames = names
        }
      case .failure(let error):
        let alert = AlertFactory.makeErrorAlert(for: error)
        DispatchQueue.main.async {
          self.present(alert, animated: true)
        }
      }
    }
  }
  
  /// API를 통해 환율 데이터를 받아오고 CurrencyItem 배열로 변환 후 즐겨찾기 반영하는 함수.
  private func fetchExchangeRate() {
    exchangeRateService.fetchSortedRates { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let sortedRates):
        DispatchQueue.main.async {
          self.allItems = sortedRates.map { (code, rate) in
            let name = self.currencyNameService.currencyNames[code] ?? "알 수 없음"
            return CurrencyItem(code: code, name: name, rate: rate, isFavorite: false)
          }
          self.syncFavorites()
        }
      case .failure(let error):
        print("데이터 로드 실패: \(error)")
        DispatchQueue.main.async {
          self.present(AlertFactory.makeErrorAlert(for: CurrencyError.decodingFailed(error)), animated: true)
        }
      }
    }
  }
  
  /// CoreData에서 즐겨찾기 리스트를 가져와 allItems에 isFavorite 값을 반영한 뒤 테이블 뷰 갱신하는 함수.
  private func syncFavorites() {
    do {
      let favCodes = try FavoriteStore.shared.fetchFavorites()
      allItems = allItems.map {
        var item = $0
        item.isFavorite = favCodes.contains($0.code)
        return item
      }
      exchangeRateView.tableView.reloadData()
    } catch {
      print("즐겨찾기 로드 실패: \(error)")
    }
  }
  
  /// 즐겨찾기 버튼 클릭 시 호출되는 함수로, 해당 아이템의 즐겨찾기 상태를 토글하고 CoreData에 반영하는 함수.
  @objc private func handleFavoriteTapped(_ sender: UIButton) {
    let tag = sender.tag
    let section = tag / 10000 // 10000 : 섹션 때문에 태그 분리용
    let row = tag % 10000
    let indexPath = IndexPath(row: row, section: section)
    
    guard let item = item(at: indexPath),
          let index = allItems.firstIndex(where: { $0.code == item.code }) else {
      return
    }
    
    allItems[index].isFavorite.toggle()
    
    // CoreData에 아이템 즐겨찾기 상태 반영
    do {
      if allItems[index].isFavorite {
        try FavoriteStore.shared.addFavorite(item: allItems[index])
      } else {
        try FavoriteStore.shared.removeFavorite(code: item.code)
      }
    } catch {
      print("CoreData 에러: \(error)")
    }
    
    // 필터링 중(검색중)이면 필터 유지
    if isFiltering {
      let searchText = exchangeRateView.searchBar.text ?? ""
      applyFilter(searchText: searchText)
    } else {
      exchangeRateView.tableView.reloadData()
    }
  }
  
  /// 검색어 기준으로 데이터를 필터링하고 결과를 테이블뷰에 반영하는 함수.
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
  
  /// 즐겨찾기 또는 전체 섹션에 따라 환율 아이템 목록을 반환하며, 검색중인 경우 필터링된 목록을 반환하는 함수.
  private func sectionItems(for section: Int) -> [CurrencyItem] {
    if section == 0 { // 즐겨찾기 섹션
      return isFiltering ? filteredFavoriteItems : favoriteItems
    } else { // 기본 섹션
      return isFiltering ? filteredAllItems : allItems
    }
  }
  
  /// indexPath 위치의 CurrencyItem을 반환하는 함수.
  private func item(at indexPath: IndexPath) -> CurrencyItem? {
    let items = sectionItems(for: indexPath.section)
    return indexPath.row < items.count ? items[indexPath.row] : nil // 재사용 등으로 인해 indexPath.row 값에 문제가 있는 경우 nil 반환
  }
}

// MARK: - UITableViewDataSource

extension ExchangeRateViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int { 2 }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sectionItems(for: section).count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell,
          let item = item(at: indexPath) else {
      return UITableViewCell()
    }
    
    cell.configureCell(code: item.code, name: item.name, rate: item.rate, isFavorite: item.isFavorite)
    cell.favoriteButton.tag = indexPath.section * 10000 + indexPath.row // 정확한 위치를 식별할 수 있도록 tag 설정
    cell.favoriteButton.addTarget(self, action: #selector(handleFavoriteTapped(_:)), for: .touchUpInside) // 즐겨찾기 버튼 이벤트 연결
    
    return cell
  }
}

// MARK: - UITableViewDelegate

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = item(at: indexPath) else { return }
    let vc = CalculatorViewController(item.code, item.name, item.rate)
    navigationController?.pushViewController(vc, animated: true)
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  // 섹션 헤더 설정 - 즐겨찾기에 항목 있을 때만 양쪽 헤더 표시
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let hasFavorites = isFiltering ? !filteredFavoriteItems.isEmpty : !favoriteItems.isEmpty

    if section == 0 {
      return hasFavorites ? "즐겨찾기" : nil
    } else {
      return hasFavorites ? "전체" : nil
    }
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    exchangeRateView.endEditing(true)
  }
}

// MARK: - UISearchBarDelegate

extension ExchangeRateViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    applyFilter(searchText: searchText)
  }
}
