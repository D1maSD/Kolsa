////
////  File.swift
////  Kolsa
////
////  Created by Dima Melnik on 7/5/25.
////
import UIKit

final class ProductPopupView: UIView {
    private let titleLabel = UILabel()
    private let priceLabel = UILabel()
    private let descLabel = UILabel()
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
        priceLabel.textColor = .gray
        priceLabel.textAlignment = .center

        descLabel.font = .systemFont(ofSize: 15)
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 0
        descLabel.textAlignment = .center

        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(descLabel)
        addSubview(stack)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }

    private func configure(with product: Product) {
        titleLabel.text = product.name
        priceLabel.text = String(format: "%.2f ₽", product.price)
        descLabel.text = product.description
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
