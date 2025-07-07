////
////  File.swift
////  Kolsa
////
////  Created by Dima Melnik on 7/5/25.
////
//
import UIKit

final class ProductCell: UITableViewCell {
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let sortButton = UIButton(type: .system)
    private let separator = UIView()
    let sortHighlightView = UIView()
    private var highlightLeadingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = .white

        nameLabel.numberOfLines = 0
        nameLabel.font = .systemFont(ofSize: 17)
        nameLabel.textColor = .black
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        priceLabel.font = .systemFont(ofSize: 17)
        priceLabel.textColor = .gray
        priceLabel.textAlignment = .right
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false

        sortButton.setTitleColor(.systemBlue, for: .normal)
        sortButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        sortButton.backgroundColor = UIColor(white: 0.94, alpha: 1)
        sortButton.layer.cornerRadius = 8
        sortButton.clipsToBounds = true
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
        sortButton.isHidden = true

        separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        separator.translatesAutoresizingMaskIntoConstraints = false

        sortHighlightView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        sortHighlightView.layer.cornerRadius = 5
        sortHighlightView.translatesAutoresizingMaskIntoConstraints = false
        sortHighlightView.isHidden = true

        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(sortButton)
        contentView.addSubview(separator)
        contentView.addSubview(sortHighlightView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: priceLabel.leadingAnchor, constant: -8),

            priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            priceLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100),

            sortButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            sortButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),

            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with product: Product) {
        nameLabel.text = product.name
        nameLabel.textAlignment = .left
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17)
        separator.isHidden = false
        priceLabel.text = String(format: "%.2f ₽", product.price)
        priceLabel.textColor = .gray
        priceLabel.font = .systemFont(ofSize: 17)
        sortHighlightView.isHidden = true
        sortButton.isHidden = true
    }

    func configureAsSortToggle(title: String, target: Any?, action: Selector) {
        sortButton.setTitle(title, for: .normal)
        sortButton.isHidden = false
        sortButton.removeTarget(nil, action: nil, for: .allEvents)
        sortButton.addTarget(target, action: action, for: .touchUpInside)

        sortButton.setImage(nil, for: .normal)
        sortButton.subviews.forEach {
            if $0 is UIImageView { $0.removeFromSuperview() }
        }
        sortButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)

        nameLabel.text = nil
        priceLabel.text = nil
        separator.isHidden = true

        let icon = UIImageView(image: UIImage(named: "filter"))
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.contentMode = .scaleAspectFit

        sortButton.addSubview(icon)

        NSLayoutConstraint.activate([
            icon.widthAnchor.constraint(equalToConstant: 15),
            icon.heightAnchor.constraint(equalToConstant: 15),
            icon.centerYAnchor.constraint(equalTo: sortButton.centerYAnchor),
            icon.trailingAnchor.constraint(equalTo: sortButton.trailingAnchor, constant: -10)
        ])

        let titleWidth = (title as NSString).size(withAttributes: [.font: sortButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 15)]).width
        let finalWidth = titleWidth + 30 + 20

        sortButton.constraints.forEach {
            if $0.firstAttribute == .width {
                sortButton.removeConstraint($0)
            }
        }

        sortButton.widthAnchor.constraint(equalToConstant: finalWidth).isActive = true
        sortHighlightView.isHidden = true
    }

    func configureAsHeader(selectedSort: SortingType) {
        nameLabel.text = "Название"
        nameLabel.textColor = .gray
        nameLabel.font = .systemFont(ofSize: 15, weight: .medium)
        nameLabel.textAlignment = .left

        priceLabel.text = "Цена"
        priceLabel.textColor = .gray
        priceLabel.font = .systemFont(ofSize: 15, weight: .medium)

        sortButton.isHidden = true
        separator.isHidden = false

        sortHighlightView.isHidden = false

        let targetLabel = (selectedSort == .name) ? nameLabel : priceLabel

        highlightLeadingConstraint?.isActive = false

        highlightLeadingConstraint = sortHighlightView.leadingAnchor.constraint(equalTo: targetLabel.leadingAnchor, constant: -4)

        NSLayoutConstraint.deactivate(sortHighlightView.constraints)

        NSLayoutConstraint.activate([
            sortHighlightView.topAnchor.constraint(equalTo: targetLabel.topAnchor, constant: -2),
            sortHighlightView.heightAnchor.constraint(equalTo: targetLabel.heightAnchor, constant: 4),
            sortHighlightView.widthAnchor.constraint(equalTo: targetLabel.widthAnchor, constant: 8),
            highlightLeadingConstraint!
        ])

        layoutIfNeeded()

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
