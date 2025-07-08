//
//  ViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

// mvvm에서 뷰는 로직이 없어야 되고, 뷰모델은 UIKit이 없어야 한다.

import UIKit

class ViewController: UIViewController {
  
  private let exchangeRateView = ExchangeRateView()
  private let exchangeRateService = ExchangeRateService()
  private let currencyNameService = CurrencyNameService()
  private var dataSource = [(code: String, rate: Double)]()
  private var currencyNames = [String: String]()
  
  override func loadView() {
    self.view = exchangeRateView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
    exchangeRateView.tableView.dataSource = self
    exchangeRateView.tableView.delegate = self
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
          self.exchangeRateView.tableView.reloadData()
        }
      case .failure(let error):
        print("데이터 로드 실패: \(error)")
        self.showAlert(title: "경고", message: "데이터를 불러올 수 없습니다.")
      }
    }
  }
  
  private func loadCurrencyNames() {
    currencyNameService.loadCurrencyNames { [weak self] names in
      guard let self, let names = names else { return }
      self.currencyNames = names
    }
  }
  
  private func showAlert(title: String, message: String) {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "닫기", style: .cancel))
    present(alertController, animated: true)
  }
}

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    dataSource.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.id) as? ExchangeRateCell else {
      return UITableViewCell()
    }
    cell.configureCell(
      code: dataSource[indexPath.row].code,
      name: currencyNames[dataSource[indexPath.row].code] ?? "알 수 없음",
      rate: dataSource[indexPath.row].rate
    )
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
}
