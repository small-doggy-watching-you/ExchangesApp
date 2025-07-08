//
//  ExchangeRateViewController.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import UIKit
import SnapKit

final class ExchangeRateViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.rowHeight = 50
        table.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier)
        return table
    }()

    private let viewModel = ExchangeRateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchRates()
    }

    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.dataSource = self
    }

    private func bindViewModel() {
        viewModel.onUpdate = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "에러", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            self?.present(alert, animated: true)
        }
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.rates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let (currency, value) = viewModel.rates[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExchangeRateCell.identifier, for: indexPath) as? ExchangeRateCell else {
            return UITableViewCell()
        }
        cell.configure(currency: currency, value: value)
        return cell
    }
}

#Preview {
    ExchangeRateViewController()
}
