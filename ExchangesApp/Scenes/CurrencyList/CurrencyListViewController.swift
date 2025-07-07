
import UIKit

import SnapKit
import Then

class CurrencyListViewController: UIViewController {
    
    
    private let dataService = DataService()
    private var currency: Currency?
    private var sortedRates: [(key: String, value: Double)] = []
    
    private let tableView = UITableView().then{
        $0.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.id)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataService.fetchData(){ [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                self.currency = result
                self.sortedRates = result?.rates.sorted { $0.key < $1.key } ?? []
                self.updateUI()
            }
        }
        
        configureUI()
    }
    
    // 최초 UI 세팅
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 40  // 예상 높이 (성능 최적화용)

        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        
    }
    
    // UI 업데이트 실행
    private func updateUI() {
        tableView.reloadData()
    }
    
}


extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.id) as? CurrencyListTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(sortedRates[indexPath.row])

        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sortedRates.count
    }
}
