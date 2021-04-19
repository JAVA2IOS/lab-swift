//
//  RootController.swift
//  lab-swift
//
//  Created by huangqing on 2021/3/30.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import UIKit

class RootController: RAMAnimatedTabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        isBottomLineShow = true
        
        hiddenTabBarLine()
        
        _initialComponentsUI()
    }
    
    // MARK: - UI
    private func _initialComponentsUI() {
        
        // 创建tabbar
        let homeTabbarItem = RAMAnimatedTabBarItem(title: "首页", image: nil, selectedImage: nil)
        
        homeTabbarItem.animation = RAMRightRotationAnimation()
        
        let homeNav = UINavigationController(rootViewController: HomeViewController())
        
        homeNav.navigationBar.isHidden = true

        homeNav.tabBarItem = homeTabbarItem

        let meTabbarItem = RAMAnimatedTabBarItem(title: "我的", image: nil, selectedImage: nil)
        
        let meNav = UINavigationController(rootViewController: TestController())
        
        meNav.navigationBar.isHidden = true

        meNav.tabBarItem = meTabbarItem
        
        meTabbarItem.animation = RAMRightRotationAnimation()
        
        viewControllers = [homeNav, meNav]
        
        tabBar.backgroundColor = .tabBar
    }
    
    
    // MARK: - Logic
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        tabBar.backgroundColor = .tabBar
    }

    
    // MARK: - Data
    private func _initialComponentsDatas() {}
    
    
    // MARK: - setter & getter
}
