
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 마지막 화면 저장
        CoreDataManager.shared.saveLastScrren(screenType: LastScreenType.calcuator.rawValue, currencyCode: viewModel.state.currencyItem.code)
    }

    // 뷰모델을 바라보는 요소들을 업데이트
    func updateUI(_ state: CalculatorViewModel.State) {
        calculatorView.currencyLabel.text = state.currencyText
        calculatorView.countryLabel.text = state.countryNameText
        calculatorView.resultLabel.text = state.resultText
    }

    // 좌우 공백 제거, 향후 regExp기반으로 변경처리
    func modifyInputText(_ inputText: String) {
        // 복사 등으로 딸려오는 공백 제거
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)

        // 첫번째가 숫자나 소수점이 아닌경우 빈 텍스트로 변경
        guard let first = trimmed.first, first.isNumber || first == "." else {
            calculatorView.amountTextField.text = ""
            return
        }

        // 정상적인 입력까지 값 획득
        var result = ""
        var hasDot = false
        for char in trimmed {
            if char.isNumber {
                result.append(char)
            } else if char == "." {
                if hasDot { break } // 소숫점은 하나만 허용
                result.append(char)
                hasDot = true
            } else { // 예외가 발생하면 그 뒤 값은 전부 파기
                break
            }
        }

        if result.last == "." { // 마지막이 소숫점일 경우 .00으로 변경
            result = result + "00"
        }

        if result.first == "." { // .12 -> 0.12
            result = "0" + result
        }

        // 정상적으로 입력된 값을 필드에 반환
        calculatorView.amountTextField.text = result
    }

    // 변환 버튼 액션
    @objc
    func convertButtonTapped() {
        let inputText = calculatorView.amountTextField.text ?? ""
        viewModel.action(.currencyExchange(inputText))
        modifyInputText(inputText)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
