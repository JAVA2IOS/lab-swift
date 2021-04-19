//
//  UIColor.extension.swift
//  lab-swift
//
//  Created by huangqing on 2021/4/12.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import Foundation

import UIKit

protocol HexColor {
    
    /// 初始化颜色
    var color : UIColor { get }
}

extension HexColor where Self == String {
    
    /// 主题配色
    var themeColor: UIColor {
        
        let themeComponents = self.split(separator: "|")
        
        if themeComponents.count <= 0 {

            return .white
        }
        
        if themeComponents.count >= 2 {
            
            if SystemIsDarkMode() {
                
                let darkColorComponents = String(themeComponents[1]).trimmingCharacters(in: CharacterSet(charactersIn: " "))
                
                if darkColorComponents.count > 0 {
                    
                    return darkColorComponents.color
                }
            }
        }
        
        return String(themeComponents.first!.trimmingCharacters(in: CharacterSet(charactersIn: " "))).color
    }

    var color: UIColor {
        
        let colorsComponents = self.split(separator: ",")
        
        if colorsComponents.count <= 0 {

            return .white
        }
        
        // 当作 hexstring, alpha
        if colorsComponents.count == 2 {
            
            let alphaString = String(colorsComponents.last!).trimmingCharacters(in: CharacterSet(charactersIn: " "))
            
            if let alpha = Float(alphaString) {

                return UIColor(hex: self).alpha(CGFloat(alpha))
            }
        }
        
        return UIColor(hex: self)
    }
}

extension String: HexColor {}



// MARK: - 主题配色
extension UIColor {
    
    /// 导航栏标题颜色
    class var navTitle: UIColor {

        return "#98ddca | #464f41, 0".themeColor
    }
    
    /// 导航栏颜色
    class var navbar: UIColor {

        return "#98ddca | #464f41".themeColor
    }
    
    /// tabbar颜色
    class var tabBar: UIColor {
        
        return "#98ddca | #464f41".themeColor
    }
}
