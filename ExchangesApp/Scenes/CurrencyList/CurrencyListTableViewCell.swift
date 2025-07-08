
import UIKit

import SnapKit
import Then

class CurrencyListTableViewCell: UITableViewCell {
    // 테이블 뷰 셀 식별id
    static let id = "CurrencyListTableViewCell"
    
    private let labelStackView = UIStackView().then{
        $0.axis = .vertical
        $0.spacing = 4
    }

    // 통화 코드 라벨
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .label
    }
    
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .gray
        $0.textAlignment = .right
    }

    // 통화 숫자 라벨
    private let rateLabel = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    // init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    // 최초 실행시 레이아웃 설정
    func setupLayout() {
        labelStackView.addArrangedSubview(currencyLabel)
        labelStackView.addArrangedSubview(countryLabel)
        
        contentView.addSubview(labelStackView)
        contentView.addSubview(rateLabel)

        // 오토 레이아웃
        
        labelStackView.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }

    }

    // 셀 생성 함수
    func configureCell(_ rate: (key: String, value: Double)) {
        currencyLabel.text = rate.key
        rateLabel.text = String(format: "%.4f", rate.value)
        countryLabel.text = CurrencyCodeMap.countryName(rate.key)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
