//
//  TransactionsViewController.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    private lazy var addButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold))
        config.cornerStyle = .capsule
        config.baseBackgroundColor = AppColors.accent
        config.baseForegroundColor = .white
        
        let btn = UIButton(configuration: config)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.shadowColor = AppColors.accent.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 4)
        btn.layer.shadowOpacity = 0.4
        btn.layer.shadowRadius = 8
        btn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupNavigationBar()
        
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppConstants.Padding.lg),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -AppConstants.Padding.lg),
            addButton.widthAnchor.constraint(equalToConstant: 56),
            addButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc private func addTapped() {
        let vc = AddTransactionViewController()
        vc.onSave = { [weak self] in
            //
        }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        present(nav, animated: true)
    }
}
