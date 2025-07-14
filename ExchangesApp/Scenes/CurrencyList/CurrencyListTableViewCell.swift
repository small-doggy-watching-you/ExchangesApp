
import UIKit

import SnapKit
import Then

class CurrencyListTableViewCell: UITableViewCell {
    // 테이블 뷰 셀 식별id
    static let id = "CurrencyListTableViewCell"

    var onFavoriteTapped: (() -> Void)?

    // 라벨 스택 뷰
    private let labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    // 통화 코드 라벨
    private let currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .label
    }

    // 국가명 라벨
    private let countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .right
    }

    // 통화 숫자 라벨
    private let rateLabel = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    // 상승하락 버튼
    private let trendImageView = UIImageView()

    // 즐겨찾기 버튼
    private let favoriteButton = UIButton(type: .custom).then {
        $0.tintColor = .systemYellow
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

        // 즐겨찾기 버튼에는 액션만 주입 -> 내용 정의는 VC 셀 정의 부분에서
        favoriteButton.addAction(UIAction { [weak self] _ in
            self?.onFavoriteTapped?()
        }, for: .touchUpInside)

        contentView.addSubview(labelStackView)
        contentView.addSubview(rateLabel)
        contentView.addSubview(trendImageView)
        contentView.addSubview(favoriteButton)

        // 오토 레이아웃
        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(trendImageView.snp.leading).offset(-8)
            $0.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            $0.width.equalTo(120)
        }

        trendImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(favoriteButton.snp.leading).offset(-8)
        }

        favoriteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }

    // 셀 생성 함수
    func configureCell(_ item: CurrencyItem) {
        // 라벨 텍스트명 주입
        currencyLabel.text = item.code
        rateLabel.text = String(format: "%.4f", item.rate)
        countryLabel.text = item.countryName

        // 상승하락 심볼
        if item.trendSymbol == .blank { // 상승 하락 버튼이 없으면
            let trendConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
            trendImageView.image = UIImage(systemName: item.trendSymbol.rawValue, withConfiguration: trendConfiguration)
            trendImageView.isHidden = true // 크기는 유지하되 히든
        } else { // 상승 하락 버튼이 있으면
            let trendConfiguration = UIImage.SymbolConfiguration(pointSize: 20).applying(UIImage.SymbolConfiguration(paletteColors: [.white, .systemBlue]))
            trendImageView.image = UIImage(systemName: item.trendSymbol.rawValue, withConfiguration: trendConfiguration)
            trendImageView.isHidden = false // 위치가 바뀌니까 히든 해제해야함
        }

        // 즐겨찾기 버튼 별 모양 판정
        let favoriteConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        let favoriteImageName = item.isFavorited == true ? "star.fill" : "star"
        favoriteButton.setImage(UIImage(systemName: favoriteImageName, withConfiguration: favoriteConfiguration), for: .normal)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
