
import UIKit

import SnapKit
import Then

final class CurrencyListView: UIView {
    
    private var viewModel: CurrencyListViewModel?
    private let searchBar = UISearchBar().then {
        $0.searchTextField.backgroundColor = .systemGray6
        $0.placeholder = "통화 검색"
        $0.searchBarStyle = .default
    }
    private let tableView = UITableView().then {
        $0.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.id)
    }

    // 뷰모델을 전달 받아 최초 뷰 셋업설정
    func setupWithViewModel(_ viewModel: CurrencyListViewModel) {
        backgroundColor = .systemBackground // 배경색 설정
        self.viewModel = viewModel // 뷰모델 주입

        // 테이블 뷰 셀 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60 // 과제 제약조건
        
        // 뷰에 주입
        addSubview(searchBar)
        addSubview(tableView)

        // 오토 레이아웃
        searchBar.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview() // 과제 제약조건보다 자연스럽게 설정
        }

        // 테이블 뷰 리로드 함수 실행
        reloadData()
    }

    // 테이블 뷰 리로드
    func reloadData() {
        tableView.reloadData()
    }
}

extension CurrencyListView: UITableViewDelegate, UITableViewDataSource {
    // 어떤 데이터를 넣을 것인지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rate = viewModel?.item(at: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.id) as? CurrencyListTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(rate)

        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel?.numberOfItems ?? 0 // 테이블 뷰 행숫자
    }
}
