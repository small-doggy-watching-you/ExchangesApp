
import UIKit

import SnapKit
import Then

class CurrencyListViewController: UIViewController {
    private let currencyListViewModel = CurrencyListViewModel()
    private let currencyListView = CurrencyListView()

    // 사용자 정의 뷰로 오버라이드
    override func loadView() {
        view = currencyListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyListViewModel.fetchData { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                currencyListView.setupWithViewModel(currencyListViewModel)
            case let .failure(error):
                let message = ErrorMessageProvider.message(for: error)
                let alert = AlertFactory.errorAlert(message: message)
                self.present(alert, animated: true)
            }
        }
    }

    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
