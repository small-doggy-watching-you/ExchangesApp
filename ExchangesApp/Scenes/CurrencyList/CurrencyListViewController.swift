
import UIKit

import SnapKit
import Then

class CurrencyListViewController: UIViewController {
    // 객체 생성
    private let currencyListViewModel = CurrencyListViewModel()
    private let currencyListView = CurrencyListView()

    // 사용자 정의 뷰로 오버라이드
    override func loadView() {
        view = currencyListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyListView.delegate = self // Delegate 주입

        // 데이터 파싱 후 성공/실패 후 처리
        currencyListViewModel.fetchData { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.currencyListView.setupWithViewModel(self.currencyListViewModel)
                case let .failure(error):
                    let message = ErrorMessageProvider.message(for: error)
                    let alert = AlertFactory.errorAlert(message: message)
                    self.present(alert, animated: true)
                }
            }
        }

        // 뷰모델 업데이트 감지
        currencyListViewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.currencyListView.reloadData()
            }
        }
    }

    // 에러 출력 함수
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

// 뷰와 연결된 Delegate
extension CurrencyListViewController: CurrencyListDelegate {
    func didSearchbarTextChange(_ searchText: String) {
        currencyListViewModel.updateSearchedData(searchText)
    }
}
