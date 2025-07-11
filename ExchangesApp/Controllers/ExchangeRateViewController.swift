//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 김우성 on 7/7/25.
//

// View (View+Controller) 는 보여주는 것만

import UIKit

final class ExchangeRateViewController: UIViewController {
  
  private let exchangeRateView = ExchangeRateView()
  private let viewModel = ExchangeRateViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupDelegates()
    bindViewModel()
    viewModel.action(.onAppear)
  }
  
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
  
  private func bindViewModel() {
    viewModel.onStateChanged = { [weak self] state in
      guard let self else { return }
      let items = self.currentItems(from: state)
      self.exchangeRateView.emptyLabel.isHidden = !items.isEmpty
      self.exchangeRateView.tableView.reloadData()
    }
  }
  
  private func currentItems(from state: ExchangeRateViewModel.State) -> [CurrencyItem] {
    state.isFiltering ? viewModel.filteredItems : state.items
  }
  
  private func sectionItems(for section: Int) -> [CurrencyItem] {
    let state = viewModel.state
    let items = currentItems(from: state)
    let favorites = items.filter { $0.isFavorite }
    return section == 0 ? favorites : items
  }
  
  private func item(at indexPath: IndexPath) -> CurrencyItem? {
    let items = sectionItems(for: indexPath.section)
    return indexPath.row < items.count ? items[indexPath.row] : nil
  }
  
  private func flatIndex(for indexPath: IndexPath) -> Int? {
    let stateItems = currentItems(from: viewModel.state)
    guard let item = item(at: indexPath),
          let index = stateItems.firstIndex(where: { $0.code == item.code }) else { return nil }
    return index
  }
  
  @objc private func handleFavoriteTapped(_ sender: UIButton) {
    guard let indexPath = exchangeRateView.indexPath(for: sender),
          let item = item(at: indexPath) else { return }
    viewModel.action(.toggleFavorite(code: item.code))
  }
}

extension ExchangeRateViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int { 2 }
  
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

extension ExchangeRateViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 60 }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let item = item(at: indexPath) else { return }
    
    let backItem = UIBarButtonItem()
    backItem.title = exchangeRateView.titleLabel.text ?? "뒤로"
    navigationItem.backBarButtonItem = backItem
    
    try? AppStateStore().saveLastScreenState(screen: "calculator", item: item)
    
    let vc = CalculatorViewController(item: item)
    navigationController?.pushViewController(vc, animated: true)
    
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    let favorites = sectionItems(for: 0)
    return section == 0 ? (favorites.isEmpty ? nil : "즐겨찾기") : (favorites.isEmpty ? nil : "전체")
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    view.endEditing(true)
  }
}

extension ExchangeRateViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.action(.search(query: searchText))
  }
}
