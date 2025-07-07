
import UIKit

import SnapKit
import Then

final class CurrencyListView: UIView {
    private var viewModel: CurrencyListViewModel?
    private let tableView = UITableView().then {
        $0.register(CurrencyListTableViewCell.self, forCellReuseIdentifier: CurrencyListTableViewCell.id)
    }

    // 뷰모델을 전달 받아 최초 뷰 셋업설정
    func setupWithViewModel(_ viewModel: CurrencyListViewModel) {
        backgroundColor = .systemBackground // 배경색 설정
        self.viewModel = viewModel // 뷰모델 주입

        // 테이블 뷰 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 자동 높이지정
        tableView.estimatedRowHeight = 40 // 예상 높이 (성능 최적화용)

        addSubview(tableView)

        // 오토 레이아웃
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
