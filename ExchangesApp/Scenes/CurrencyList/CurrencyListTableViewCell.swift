
import UIKit

import SnapKit
import Then

class CurrencyListTableViewCell: UITableViewCell {
    
    static let id = "CurrencyListTableViewCell"
    
    private let currencyCode = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .left
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    private let currencyValue = UILabel().then {
        $0.textColor = .label
        $0.textAlignment = .right
        $0.font = .systemFont(ofSize: 17, weight: .medium)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    func setupLayout() {
        
        contentView.addSubview(currencyCode)
        contentView.addSubview(currencyValue)
        
        currencyCode.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
    }
    
    
    func configureCell(_ rate: (key: String, value: Double) ) {
        currencyCode.text = rate.key
        currencyValue.text = String(format: "%.4f", rate.value)
        
        currencyValue.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
