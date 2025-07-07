////
////  File.swift
////  Kolsa
////
////  Created by Dima Melnik on 7/5/25.
////
import UIKit
import SnapKit

final class ProductPopupView: UIView {
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let rubleLabel = UILabel()
    private let descLabel = UILabel()
    private let priceStack = UIStackView()
    private let stack = UIStackView()

    init(product: Product) {
        super.init(frame: .zero)
        setupViews()
        setupConstraints()
        configure(with: product)
    }

    private func setupViews() {
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true

        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 0

        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = .black

        rubleLabel.font = .boldSystemFont(ofSize: 16)
        rubleLabel.textColor = .gray

        descLabel.font = .systemFont(ofSize: 15)
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center

        priceStack.axis = .horizontal
        priceStack.spacing = 2
        priceStack.alignment = .center
        priceStack.distribution = .fill
        priceStack.addArrangedSubview(priceLabel)
        priceStack.addArrangedSubview(rubleLabel)

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .fill

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(priceStack)
        stack.addArrangedSubview(descLabel)

        addSubview(stack)
    }

    private func setupConstraints() {
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(20)
        }
    }

    private func configure(with product: Product) {
        titleLabel.text = product.name
        priceLabel.text = String(format: "%.2f", product.price)
        rubleLabel.text = "₽"
        descLabel.text = product.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
