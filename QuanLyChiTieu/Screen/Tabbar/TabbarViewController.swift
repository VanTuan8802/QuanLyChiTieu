//
//  TabbarViewController.swift
//  QuanLyChiTieu
//
//  Created by Nguyễn Tuấn on 08/08/2023.
//

import UIKit
import ESTabBarController_swift

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        loadTabBarView()
        selectedIndex = 0
    }
    
    private func setupTabBarAppearance() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().tintColor = .lightGray
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
    }
    
    private func loadTabBarView() {
        let home = createViewController(withIdentifier: "HomeViewController", title: "Home", image: "home")
        let income = createViewController(withIdentifier: "IncomeViewController", title: "Thu nhập", image: "message")
        let spending = createViewController(withIdentifier: "SpendingViewController", title: "Chi tiêu", image: "user")
        let account = createViewController(withIdentifier: "AccountViewController", title: "Tài khoản", image: "home")
        
        setViewControllers([home, income,spending, account], animated: true)
    }
    
    private func createViewController(withIdentifier: String, title: String, image: String) -> UIViewController {
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: withIdentifier)
        let image = UIImage(named: image)
        let selectedImage = image?.withRenderingMode(.alwaysOriginal)
        let tabBarItem = ESTabBarItem(CustomStyleTabBarContentView(), title: title.uppercased(), image: image, selectedImage: selectedImage)
        viewController.tabBarItem = tabBarItem
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }
}
