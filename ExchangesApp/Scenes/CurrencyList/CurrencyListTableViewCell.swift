
import UIKit

import SnapKit
import Then

class CurrencyListTableViewCell: UITableViewCell {
    // 테이블 뷰 셀 식별id
    static let id = "CurrencyListTableViewCell"

    // 통화 코드 라벨
    private let currencyCode = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }

    // 통화 숫자 라벨
    private let currencyValue = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }

    // init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    // 최초 실행시 레이아웃 설정
    func setupLayout() {
        contentView.addSubview(currencyCode)
        contentView.addSubview(currencyValue)

        // 오토 레이아웃
        currencyCode.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }

        currencyValue.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }

    // 셀 생성 함수
    func configureCell(_ rate: (key: String, value: Double)) {
        currencyCode.text = rate.key
        currencyValue.text = String(format: "%.4f", rate.value)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
