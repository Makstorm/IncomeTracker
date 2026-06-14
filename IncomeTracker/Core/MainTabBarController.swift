//
//  MainTabBarController.swift
//  IncomeTracker
//
//  Created by Maxym Horobets on 12.06.2026.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        print("View did load triggered")
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }

    private func setupTabs() {
        let dashboard = makeNav(
            root: DashboardViewController(),
            title: "Dashboard",
            icon: "house.fill"
        )

        let transactions = makeNav(
            root: TransactionsViewController(),
            title: "Transactions",
            icon: "list.bullet.rectangle"
        )

        let analytics = makeNav(
            root: AnalyticsViewController(),
            title: "Analytics",
            icon: "chart.pie.fill"
        )

        let settings = makeNav(
            root: SettingsViewController(),
            title: "Settings",
            icon: "gearshape.fill"
        )

        viewControllers = [dashboard, transactions, analytics, settings]
    }

    private func makeNav(root: UIViewController, title: String, icon: String) -> UINavigationController {
        root.title = title
        
        let nav = UINavigationController(rootViewController: root)

        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: icon),
            selectedImage: nil
        )

        return nav
    }

    private func setupAppearance() {
        tabBar.tintColor = AppColors.accent

        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }

}

#Preview {
    MainTabBarController()
}
