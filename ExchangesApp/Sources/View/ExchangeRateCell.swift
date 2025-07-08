//
//  ExchangeRateCell.swift
//  ExchangesApp
//
//  Created by 노가현 on 7/7/25.
//

import UIKit

final class ExchangeRateCell: UITableViewCell {
    static let identifier = "ExchangeRateCell"

    private let currencyLabel = UILabel()
    private let valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }

    func configure(currency: String, value: Double) {
        currencyLabel.text = currency
        valueLabel.text = String(format: "%.4f", value)
    }

    private func setupLayout() {
        currencyLabel.font = .systemFont(ofSize: 16, weight: .medium)
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.textAlignment = .right

        let stack = UIStackView(arrangedSubviews: [currencyLabel, valueLabel])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}
