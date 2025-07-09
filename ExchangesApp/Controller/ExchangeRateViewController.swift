//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

// mvvm에서 뷰는 로직이 없어야 되고, 뷰모델은 UIKit이 없어야 한다.

import UIKit

class ExchangeRateViewController: UIViewController {
  
  private let exchangeRateView = ExchangeRateView()
  private let exchangeRateService = ExchangeRateService()
  private let currencyNameService = CurrencyNameService()
  private var currencyNames = [String: String]()
  private var dataSource = [(code: String, rate: Double)]()
  private var filteredDataSource = [(code: String, rate: Double)]()
  
  override func loadView() {
    self.view = exchangeRateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.tableView.delegate = self
    exchangeRateView.searchBar.delegate = self
    loadCurrencyNames()
    fetchExchangeRate()
  }
  
  private func fetchExchangeRate() {
    exchangeRateService.fetchSortedRates { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let sortedRates):
        DispatchQueue.main.async {
          self.dataSource = sortedRates
          self.filteredDataSource = sortedRates
          self.exchangeRateView.tableView.reloadData()
        }
      case .failure(let error):
        print("데이터 로드 실패: \(error)")
        DispatchQueue.main.async {
          self.present(AlertFactory.makeErrorAlert(for: CurrencyError.decodingFailed(error)), animated: true)
        }
      }
    }
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
}

extension ExchangeRateViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    filteredDataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else {
      return UITableViewCell()
    }
    cell.configureCell(
      code: filteredDataSource[indexPath.row].code,
      name: currencyNames[filteredDataSource[indexPath.row].code] ?? "알 수 없음",
      rate: filteredDataSource[indexPath.row].rate
    )
    return cell
  }
}

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
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
        currencyNames[$0.code]?.lowercased().contains(searchText.lowercased()) ?? false
      }
    }
    if filteredDataSource.isEmpty {
      exchangeRateView.emptyLabel.isHidden = false
    } else {
      exchangeRateView.emptyLabel.isHidden = true
    }
    exchangeRateView.tableView.reloadData()
  }
}
