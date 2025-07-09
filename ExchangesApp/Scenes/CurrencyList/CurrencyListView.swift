
import UIKit

import SnapKit
import Then

final class CurrencyListView: UIView {
    // Delegate
    weak var delegate: CurrencyListDelegate?

    // 객체 선언부
    private var viewModel: CurrencyListViewModel?

    // UI 구성요소 선언
    let searchBar = UISearchBar().then {
        $0.searchTextField.backgroundColor = .systemGray6
        $0.placeholder = "통화 검색"
        $0.searchBarStyle = .default
    }

    let tableView = UITableView().then {
        $0.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.id)
    }

    private let emptyLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textAlignment = .center
        $0.textColor = .secondaryLabel
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.isHidden = true
    }

    // 뷰모델을 전달 받아 최초 뷰 셋업설정
    func setupWithViewModel(_ viewModel: CurrencyListViewModel) {
        backgroundColor = .systemBackground // 배경색 설정
        self.viewModel = viewModel // 뷰모델 주입

        // 테이블 뷰 셀 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60 // 과제 제약조건

        // 서치 바 설정
        searchBar.delegate = self

        // 뷰에 주입
        addSubview(searchBar)
        addSubview(tableView)
        addSubview(emptyLabel) // Z-index순서 나중에 추가될수록 위에 그려짐

        // 오토 레이아웃
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview() // 과제 제약조건보다 자연스럽게 설정
        }

        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }

        // 테이블 뷰 리로드 함수 실행
        reloadData()
    }

    // 테이블 뷰 리로드
    func reloadData() {
        tableView.reloadData()
        emptyLabel.isHidden = viewModel?.numberOfItems != 0 // 검색결과 0개일 경우 false로 변경
    }
}

extension CurrencyListView: UITableViewDelegate, UITableViewDataSource {
    // 어떤 데이터를 넣을 것인지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rate = viewModel?.currencyItem(at: indexPath.row), let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyListTableViewCell.id) as? CurrencyListTableViewCell else {
            return UITableViewCell()
        }
        cell.configureCell(rate)
        return cell
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel?.numberOfItems ?? 0 // 테이블 뷰 행숫자
    }

    // 행 클릭 감지
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 배경 선택상태 해제 사용자경험 개선용 코드
        if let currencyItem = viewModel?.currencyItem(at: indexPath.row) {
            delegate?.didSelectCurrency(currencyItem) // Delegate 실행
        }
    }
}

// 서치 바 Delegate
extension CurrencyListView: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        delegate?.didSearchbarTextChange(searchText)
    }
}
