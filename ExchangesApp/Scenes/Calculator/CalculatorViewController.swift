
import UIKit

import SnapKit
import Then

class CalculatorViewController: UIViewController {
    
    private let calculatorView = CalculatorView()
    private let viewModel: CalculatorViewModel
    
    init(currencyItem: CurrencyItem) {
        viewModel = CalculatorViewModel(currencyItem: currencyItem)
        
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 사용자 정의 뷰로 오버라이드
    override func loadView() {
        view = calculatorView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatorView.setupWithViewModel(viewModel)
        calculatorView.convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchDown)
    }
    
    @objc
    func convertButtonTapped() {
        let amount = calculatorView.amountTextField.text ?? ""
        viewModel.claculate(amount: amount)
    }
}


