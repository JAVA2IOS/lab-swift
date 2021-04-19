//
//  Font.extension.swift
//  lab-swift
//
//  Created by huangqing on 2021/3/30.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import Foundation

import UIKit

// MARK: - 矢量图标
extension UIFont {
    
    static func iconFont(_ size: CGFloat) -> UIFont {

        if let font = UIFont(name: "lab_ios", size: size) {

            return font
        }
        return  UIFont().withSize(size)
    }
}

extension UILabel {
    
    @discardableResult
    func iconFont(name: String, size: CGFloat) -> Self {
        font = UIFont.iconFont(size)

        text = name
        
        return self
    }
}
