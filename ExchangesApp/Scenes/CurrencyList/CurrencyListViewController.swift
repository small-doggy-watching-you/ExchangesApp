
import UIKit

import SnapKit
import Then

class CurrencyListViewController: UIViewController {
    // 객체 생성
    private let viewModel = CurrencyListViewModel()

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

    override func viewDidLoad() {
        super.viewDidLoad()

        // 데이터 파싱 후 성공/실패 후 처리
        viewModel.action(.fetchdata)

        configureUI() // UI생성

        // 데이터 변화 감지 시 테이블 뷰 리로드
        viewModel.onStateChanged = { [weak self] _ in
            guard let self else { return }
            DispatchQueue.main.async {
                self.reloadData()
            }
        }

        // 에러 발생 감지
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            DispatchQueue.main.async {
                self.presentErrorAlert(message: ErrorMessageProvider.message(for: error))
            }
        }
    }

    // 에러 출력 함수
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }

    // UI 레이아웃 생성
    func configureUI() {
        view.backgroundColor = .systemBackground // 배경색 설정

        // 테이블 뷰 셀 설정
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60 // 과제 제약조건

        // 서치 바 설정
        searchBar.delegate = self

        // 뷰에 주입
        view.addSubview(searchBar)
        view.addSubview(tableView)
        view.addSubview(emptyLabel) // Z-index순서 나중에 추가될수록 위에 그려짐

        // 오토 레이아웃
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        emptyLabel.isHidden = viewModel.state.numberOfItems != 0 // 검색결과 0개일 경우 false로 변경
    }
}

extension CurrencyListViewController: UITableViewDelegate, UITableViewDataSource {
    // 어떤 데이터를 넣을 것인지 정의
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.state.sortedItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyListTableViewCell", for: indexPath) as! CurrencyListTableViewCell
        cell.configureCell(item) // 셀 생성
        // 셀에서 즐겨찾기 버튼이 눌리면 뷰모델의 토글함수 실행 클로저
        cell.onFavoriteTapped = { [viewModel] in
            viewModel.action(.favoriteToggle(indexPath.row))
        }
        return cell
    }

    // 테이블 뷰 행 숫자 정의
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.state.numberOfItems
    }

    // 행 클릭 감지
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // 배경 선택상태 해제 사용자경험 개선용 코드
        let item = viewModel.state.sortedItems[indexPath.row] // 선택한 행의 정보 획득
        let calculatorVC = CalculatorViewController(currencyItem: item)
        navigationController?.pushViewController(calculatorVC, animated: true)
    }
}

// 서치 바 Delegate
extension CurrencyListViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.action(.updateSearchedData(searchText))
    }
}
