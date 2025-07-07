////
////  Kolsa
////
////  Created by Dima Melnik on 7/5/25.
////

import UIKit

final class ProductListViewController: UIViewController {
    private let viewModel: ProductListViewModel

    private let tableView = UITableView()
    private var blurView: UIVisualEffectView?
    private var navBarWasHidden = false

    init(viewModel: ProductListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureTableView()
        setupTableViewConstraints()
    }

    private func configureAppearance() {
        title = "Kolsa"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        view.backgroundColor = .white
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.register(ProductCell.self, forCellReuseIdentifier: "ProductCell")
        view.addSubview(tableView)
    }

    private func setupTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func didTapSortButton() {
        viewModel.toggleSort()
        tableView.reloadData()
    }
}
extension ProductListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sortedProducts.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as? ProductCell else {
            assertionFailure("❌ Failed to dequeue ProductCell. Check identifier or registration.")
            return UITableViewCell()
        }

        cell.selectionStyle = .none
        cell.separatorInset = indexPath.row == 0
            ? UIEdgeInsets(top: 0, left: .greatestFiniteMagnitude, bottom: 0, right: 0)
            : UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        switch indexPath.row {
        case 0:
            cell.configureAsSortToggle(
                title: viewModel.sortingType.title,
                target: self,
                action: #selector(didTapSortButton)
            )
        case 1:
            cell.configureAsHeader(selectedSort: viewModel.sortingType)
        default:
            let product = viewModel.sortedProducts[indexPath.row - 2]
            cell.configure(with: product)
            cell.sortHighlightView.isHidden = true
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 66 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.toggleSort()
            tableView.reloadData()
        } else if indexPath.row >= 2 {
            let product = viewModel.sortedProducts[indexPath.row - 2]
            showPopup(for: product)
        }
    }
}

private extension ProductListViewController {
    func showPopup(for product: Product) {
        toggleNavigationBarIfNeeded()
        showBlurView()
        showProductPopup(for: product)
    }

    func toggleNavigationBarIfNeeded() {
        if let nav = navigationController, !nav.isNavigationBarHidden {
            navBarWasHidden = false
            nav.setNavigationBarHidden(true, animated: true)
        } else {
            navBarWasHidden = true
        }
    }

    func showBlurView() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterialDark)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.frame = view.bounds
        blur.alpha = 0
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blur.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissPopup)))
        blur.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        view.addSubview(blur)
        blurView = blur
    }

    func showProductPopup(for product: Product) {
        let popup = ProductPopupView(product: product)
        popup.translatesAutoresizingMaskIntoConstraints = false
        popup.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:))))
        view.addSubview(popup)

        let bottomConstraint = popup.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        bottomConstraint.identifier = "popupBottom"

        NSLayoutConstraint.activate([
            popup.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            popup.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            bottomConstraint
        ])

        popup.transform = CGAffineTransform(translationX: 0, y: view.bounds.height)
        popup.alpha = 0

        UIView.animate(withDuration: 0.25) {
            self.blurView?.alpha = 1
            popup.alpha = 1
            popup.transform = .identity
        }
    }

    @objc func dismissPopup() {
        guard let blur = blurView,
              let popup = view.subviews.last(where: { $0 is ProductPopupView }) else { return }

        UIView.animate(withDuration: 0.25, animations: {
            blur.alpha = 0
            popup.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            popup.alpha = 0
        }) { _ in
            blur.removeFromSuperview()
            popup.removeFromSuperview()
        }

        UIView.animate(withDuration: 0.1) { [weak self] in
            if let nav = self?.navigationController, !(self?.navBarWasHidden ?? false) {
                nav.setNavigationBarHidden(false, animated: true)
            }
        }
    }

    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        guard let popup = view.subviews.first(where: { $0 is ProductPopupView }) else { return }

        switch gesture.state {
        case .changed:
            if translation.y > 0 {
                popup.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        case .ended:
            if translation.y > 100 {
                dismissPopup()
            } else {
                UIView.animate(withDuration: 0.2) {
                    popup.transform = .identity
                }
            }
        default:
            break
        }
    }
}

enum SortingType {
    case price, name

    var toggle: SortingType { self == .price ? .name : .price }

    var title: String {
        switch self {
        case .price: return "Sort by Name"
        case .name: return "Sort by Price"
        }
    }
}
