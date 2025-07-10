
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calculatorView)
        calculatorView.configureUI()
        updateUI()
        calculatorView.convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchDown)
        
        calculatorView.snp.makeConstraints{
            $0.directionalEdges.equalToSuperview()
        }
        
        viewModel.onDataUpdated = { [weak self] in
            guard let self else {return}
            self.updateUI()
        }
    }
    
    func updateUI() {
        calculatorView.currencyLabel.text = viewModel.currencyText
        calculatorView.countryLabel.text = viewModel.counntryNameText
        calculatorView.resultLabel.text = viewModel.resultText
    }
    
    // 좌우 공백 제거, 향후 regExp기반으로 변경처리
    func trimmedInputText(_ inputText: String) {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        // TODO: 정규식 활용 자동수정
//        let filtered = trimmed.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        calculatorView.amountTextField.text = trimmed
        
    }
    
    @objc
    func convertButtonTapped() {
        let inputText = calculatorView.amountTextField.text ?? ""
        do {
            try viewModel.currencyExchange(inputText: inputText)
        } catch {
            let alert = AlertFactory.errorAlert(message: error.localizedDescription)
            print(error.localizedDescription)
            present(alert, animated: true)
        }
        trimmedInputText(inputText)
    }
}


