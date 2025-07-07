////
////  File.swift
////  Kolsa
////
////  Created by Dima Melnik on 7/5/25.
////
//
import UIKit
import SnapKit

final class ProductCell: UITableViewCell {
    let nameLabel = UILabel()
    let priceLabel = UILabel()
    let sortButton = UIButton(type: .system)
    private let separator = UIView()
    let sortHighlightView = UIView()
    private var highlightLeadingConstraint: Constraint?

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

        priceLabel.font = .systemFont(ofSize: 17)
        priceLabel.textAlignment = .right
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

        sortButton.setTitleColor(.systemBlue, for: .normal)
        sortButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
        sortButton.backgroundColor = UIColor(white: 0.94, alpha: 1)
        sortButton.layer.cornerRadius = 8
        sortButton.clipsToBounds = true
        sortButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
        sortButton.isHidden = true

        separator.backgroundColor = UIColor(white: 0.9, alpha: 1.0)

        sortHighlightView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        sortHighlightView.layer.cornerRadius = 5
        sortHighlightView.isHidden = true

        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(sortButton)
        contentView.addSubview(separator)
        contentView.addSubview(sortHighlightView)
    }

    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.trailing.lessThanOrEqualTo(priceLabel.snp.leading).offset(-8)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-16)
            make.width.lessThanOrEqualTo(100)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        sortButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
        }

        separator.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }

    func configure(with product: Product) {
        nameLabel.text = product.name
        nameLabel.textAlignment = .left
        nameLabel.textColor = .black
        nameLabel.font = .systemFont(ofSize: 17)
        separator.isHidden = false
        sortButton.isHidden = true
        sortHighlightView.isHidden = true

        // Число чёрным, ₽ серым
        let formatted = NSMutableAttributedString(
            string: String(format: "%.2f", product.price),
            attributes: [.foregroundColor: UIColor.black]
        )
        formatted.append(NSAttributedString(string: " ₽", attributes: [.foregroundColor: UIColor.gray]))
        priceLabel.attributedText = formatted
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
        icon.contentMode = .scaleAspectFit
        sortButton.addSubview(icon)

        icon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }

        let titleWidth = (title as NSString).size(withAttributes: [.font: sortButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 15)]).width
        let finalWidth = titleWidth + 30 + 20

        sortButton.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(finalWidth)
        }

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

        sortHighlightView.snp.remakeConstraints { make in
            make.top.equalTo(targetLabel).offset(-2)
            make.height.equalTo(targetLabel).offset(4)
            make.width.equalTo(targetLabel).offset(8)
            make.leading.equalTo(targetLabel).offset(-4)
        }

        layoutIfNeeded()

        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
}
