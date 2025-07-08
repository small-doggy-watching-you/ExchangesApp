//
//  ViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

// mvvm에서 뷰는 로직이 없어야 되고, 뷰모델은 UIKit이 없어야 한다.

import UIKit

class ViewController: UIViewController {
  
  private let mainView = MainView()
  private let exchangeRateService = ExchangeRateService()
  private var dataSource = [(code: String, rate: Double)]()
  
  override func loadView() {
    self.view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print("viewDidLoad")
    fetchExchangeRate()
    mainView.tableView.dataSource = self
    mainView.tableView.delegate = self
  }
  
  private func fetchExchangeRate() {
    exchangeRateService.fetchSortedRates { [weak self] result in
      guard let self else { return }
      switch result {
      case .success(let sortedRates):
        DispatchQueue.main.async {
          self.dataSource = sortedRates
          self.mainView.tableView.reloadData()
        }
      case .failure(let error):
        print("데이터 로드 실패: \(error)")
        self.showAlert(title: "경고", message: "데이터 로드 실패")
      }
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
    guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id) as? TableViewCell else {
      return UITableViewCell()
    }
    cell.configureCell(code: dataSource[indexPath.row].code, rate: dataSource[indexPath.row].rate)
    return cell
  }
}

extension ViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    56
  }
}
