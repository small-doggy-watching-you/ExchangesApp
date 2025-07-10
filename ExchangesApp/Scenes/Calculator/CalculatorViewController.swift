
import UIKit

import SnapKit
import Then

class CalculatorViewController: UIViewController {
    // 객체 생성
    private let calculatorView = CalculatorView()
    private let viewModel: CalculatorViewModel

    init(currencyItem: CurrencyItem) {
        viewModel = CalculatorViewModel(currencyItem: currencyItem) // 이동할 때 받은 값 주입
        super.init(nibName: nil, bundle: nil) // super call 필수
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(calculatorView) // 따로 설정한 뷰 파일 추가

        calculatorView.configureUI() // UI 생성
        updateUI(viewModel.state) // 뷰모델을 바라보는 값 최초 업데이트

        // 버튼액션 주입
        calculatorView.convertButton.addTarget(self, action: #selector(convertButtonTapped), for: .touchDown)

        // 오토 레이아웃
        calculatorView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }

        // 데이터 변화 감지
        viewModel.onStateChanged = { [weak self] state in
            guard let self else { return }
            self.updateUI(state)
        }

        // 에러 발생 감지
        viewModel.onError = { [weak self] error in
            guard let self else { return }
            let alert = AlertFactory.errorAlert(message: error.localizedDescription)
            print(error.localizedDescription)
            present(alert, animated: true)
        }
    }

    // 뷰모델을 바라보는 요소들을 업데이트
    func updateUI(_ state: CalculatorViewModel.State) {
        calculatorView.currencyLabel.text = state.currencyText
        calculatorView.countryLabel.text = state.countryNameText
        calculatorView.resultLabel.text = state.resultText
    }

    // 좌우 공백 제거, 향후 regExp기반으로 변경처리
    func trimmedInputText(_ inputText: String) {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        // TODO: 정규식 또는 루프 활용 자동수정(시간이 남으면)
//        let filtered = trimmed.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        calculatorView.amountTextField.text = trimmed
    }

    // 변환 버튼 액션
    @objc
    func convertButtonTapped() {
        let inputText = calculatorView.amountTextField.text ?? ""
        viewModel.action(.currencyExchange(inputText))
        trimmedInputText(inputText)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
