//
//  MainTabbarController.swift
//  SearchBook
//
//  Created by t2023-m0019 on 12/26/24.
//

import UIKit

final class MainTabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabbar()
        setupTabBarItem()
    }
}

private extension MainTabbarController {
    func setupTabbar() {
        let appearanceTabbar = UITabBarAppearance()
        appearanceTabbar.configureWithOpaqueBackground()
        appearanceTabbar.backgroundColor = .white
        appearanceTabbar.shadowColor = UIColor.clear
        
        // 탭바 아이템 텍스트 색상 설정
        appearanceTabbar.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.gray
        ]
        appearanceTabbar.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.orange
        ]
        
        // 탭바 아이콘 색상 설정
        appearanceTabbar.stackedLayoutAppearance.selected.iconColor = UIColor.orange
        
        tabBar.standardAppearance = appearanceTabbar
        tabBar.scrollEdgeAppearance = appearanceTabbar
    }
    
    func setupTabBarItem() {
        let mainVC = MainViewController()
        let mainNavVC = UINavigationController(rootViewController: mainVC)
        mainNavVC.tabBarItem = UITabBarItem(title: "Search",
                                              image: UIImage(systemName: "magnifyingglass"),
                                              selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let likeVC = LikeViewController()
        let likeNavVC = UINavigationController(rootViewController: likeVC)
        likeNavVC.tabBarItem = UITabBarItem(title: "Like",
                                              image: UIImage(systemName: "heart"),
                                              selectedImage: UIImage(systemName: "heart"))
        
        viewControllers = [mainNavVC, likeNavVC]
    }
}
