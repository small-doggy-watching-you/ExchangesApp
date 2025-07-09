
import UIKit

import SnapKit
import Then

class CalculatorViewController: UIViewController {
    // 프로퍼티 선언
    var currencyItem: CurrencyItem? // 외부에서 주입받기 위한 변수선언

    private let calculatorView = CalculatorView()

    // 사용자 정의 뷰로 오버라이드
    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currencyItem else { return }
        let viewModel = CalculatorViewModel(currencyItem: currencyItem)
        calculatorView.setupWithViewModel(viewModel)
    }
}
