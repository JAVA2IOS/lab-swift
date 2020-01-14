//
//  ViewController.swift
//  lab-swift
//
//  Created by q huang on 2020/1/6.
//  Copyright © 2020 qeeniao35. All rights reserved.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let homeNav = UINavigationController(rootViewController: HomeViewController())
        
        let item = UITabBarItem(title: "首页", image: nil, tag: 1)
        homeNav.tabBarItem = item
        self.setViewControllers([homeNav], animated: true)

        hiddenTabBarLine()
    }
}

extension UITabBarController {
    func hiddenTabBarLine() {
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
    }
}
