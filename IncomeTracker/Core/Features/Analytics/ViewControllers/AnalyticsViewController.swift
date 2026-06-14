//
//  AnalyticsViewController.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import UIKit

class AnalyticsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
    }
}
