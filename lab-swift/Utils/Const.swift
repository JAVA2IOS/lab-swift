//
//  Const.swift
//  lab-swift
//
//  Created by huangqing on 2021/4/7.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import Foundation

import UIKit

/// 是否是暗黑模式
/// - Returns: 是否暗黑模式
func SystemIsDarkMode() -> Bool {

    if #available(iOS 12.0, *) {
        
        return UITraitCollection.current.userInterfaceStyle == .dark
    }

    return false
}


func MainWindow() -> UIWindow {

    guard let delegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate else {

        if #available(iOS 13.0, *) {
            
            guard let scene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let windowDelegate: SceneDelegate = scene.delegate as? SceneDelegate else {
                
                return UIWindow()
            }
            
            return windowDelegate.window ?? UIWindow()
        }
        
        return UIWindow()
    }

    return delegate.keyWindow!
}

func dynamicStatusHeight() -> CGFloat {

    if #available(iOS 13.0, *) {
        
        guard let scene: UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            
            return 20
        }
        
        return scene.statusBarManager?.statusBarFrame.height ?? 20
        
    }else {
        
        return UIApplication.shared.statusBarFrame.height
    }
}

/// 静态全局导航栏状态栏高度
let StaticStatusHeight = dynamicStatusHeight()


