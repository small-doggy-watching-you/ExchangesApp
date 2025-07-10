
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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(calculatorView)
        calculatorView.configureUI()
        updateUI(viewModel.state)
        calculatorView.convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchDown)

        calculatorView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }

        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            self.updateUI(state)
        }

        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = AlertFactory.errorAlert(message: error.localizedDescription)
            print(error.localizedDescription)
            present(alert, animated: true)
        }
    }

    // viewModel.state
    func updateUI(_ state: CalculatorState) {
        calculatorView.currencyLabel.text = state.currencyText
        calculatorView.countryLabel.text = state.countryNameText
        calculatorView.resultLabel.text = state.resultText
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
        viewModel.action(.currencyExchange(inputText))

        trimmedInputText(inputText)
    }
}
