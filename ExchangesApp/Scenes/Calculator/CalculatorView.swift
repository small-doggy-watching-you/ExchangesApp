
import UIKit

import SnapKit
import Then

final class CalculatorView: UIView {
    // 객체 선언
    private var viewModel: CalculatorViewModel?

    // 클로저
    var didConvertButtonTapped: ((String) -> Void)?

    // UI 구성요소 선언
    let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .label
    }

    let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }

    let amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "금액을 입력하세요"
    }

    let convertButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.setTitle("환율 계산", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
    }

    let resultLabel = UILabel().then {
        $0.text = "계산 결과가 여기에 표시됩니다."
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textColor = .label
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }

    // 뷰 모델을 받아 최초 셋업
    func configureUI() {
        backgroundColor = .systemBackground // 배경색 설정

        labelStackView.addArrangedSubview(currencyLabel)
        labelStackView.addArrangedSubview(countryLabel)

        addSubview(labelStackView)
        addSubview(amountTextField)
        addSubview(convertButton)
        addSubview(resultLabel)

        labelStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(32)
            $0.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        convertButton.snp.makeConstraints {
            $0.top.equalTo(amountTextField.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints {
            $0.top.equalTo(convertButton.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
