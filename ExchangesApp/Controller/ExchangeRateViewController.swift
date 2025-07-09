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
  
  private var currencyNames = [String: String]()
  private var dataSource = [CurrencyItem]()
  private var filteredDataSource = [CurrencyItem]()
  
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
  
  private func loadCurrencyNames() {
    currencyNameService.loadCurrencyNames { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let names):
        self.currencyNames = names
      case .failure(let error):
        let alert = AlertFactory.makeErrorAlert(for: error)
        DispatchQueue.main.async {
          self.present(alert, animated: true)
        }
      }
    }
  }
  
  private func fetchExchangeRate() {
    exchangeRateService.fetchSortedRates { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let sortedRates):
        DispatchQueue.main.async {
          self.dataSource = sortedRates.map { (code, rate) in
            CurrencyItem(
              code: code,
              name: self.currencyNames[code] ?? "알 수 없음",
              rate: rate,
              isFavorite: false
            )
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
  
  private func syncFavorites() {
    do {
      let favCodes = try FavoriteStore.shared.fetchFavorites()
      dataSource = dataSource.map {
        var mutable = $0
        mutable.isFavorite = favCodes.contains($0.code)
        return mutable
      }
      filteredDataSource = dataSource
      sortAndReload()
    } catch {
      print("즐겨찾기 로드 실패: \(error)")
    }
  }
  
  private func sortAndReload() {
    filteredDataSource.sort { (lhs, rhs) -> Bool in
      if lhs.isFavorite != rhs.isFavorite {
        return lhs.isFavorite && !rhs.isFavorite
      }
      return lhs.code < rhs.code
    }
    exchangeRateView.tableView.reloadData()
  }
  
  @objc
  private func handleFavoriteTapped(_ sender: UIButton) {
    let index = sender.tag
    var item = filteredDataSource[index]
    item.isFavorite.toggle()
    
    do {
      if item.isFavorite {
        try FavoriteStore.shared.addFavorite(item: item)
      } else {
        try FavoriteStore.shared.removeFavorite(code: item.code)
      }
    } catch {
      print("코어데이터 에러: \(error)")
    }
    
    if let originalIndex = dataSource.firstIndex(where: {$0.code == item.code}) {
      dataSource[originalIndex] = item
    }
    
    syncFavorites()
  }
  
}

extension ExchangeRateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredDataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else {
      return UITableViewCell()
    }
    let item = filteredDataSource[indexPath.row]
    cell.configureCell(code: item.code, name: item.name, rate: item.rate, isFavorite: item.isFavorite)
    cell.favoriteButton.tag = indexPath.row
    cell.favoriteButton.addTarget(self, action: #selector(handleFavoriteTapped(_:)), for: .touchUpInside)
    
    return cell
  }
}

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedRow = filteredDataSource[indexPath.row]
    let calculatorVC = CalculatorViewController(selectedRow.code, currencyNames[selectedRow.code] ?? "알 수 없음", selectedRow.rate)
    navigationController?.pushViewController(calculatorVC, animated: true)
    tableView.deselectRow(at: indexPath, animated: true) // 셀 선택 상태를 해제함
  }
}

extension ExchangeRateViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    let searchText = searchText.trimmingCharacters(in: .whitespaces)
    if searchText.isEmpty {
      filteredDataSource = dataSource
    } else {
      filteredDataSource = dataSource.filter {
        $0.code.lowercased().contains(searchText.lowercased()) ||
        $0.name.lowercased().contains(searchText.lowercased())
      }
    }
    
    if filteredDataSource.isEmpty {
      exchangeRateView.emptyLabel.isHidden = false
    } else {
      exchangeRateView.emptyLabel.isHidden = true
    }
    sortAndReload()
  }
}
