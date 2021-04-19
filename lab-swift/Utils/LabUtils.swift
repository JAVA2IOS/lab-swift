//
//  LabUtils.swift
//  lab-swift
//
//  Created by huangqing on 2021/4/13.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import Foundation

import UIKit

// MARK: - 字体
enum LabFontType {
    
    case `default`, medium, bold
}

protocol LabFontUtils {

    /// 字体
    var font: UIFont { get }
    
    /// 中等字体
    var medium: UIFont { get }
    
    /// 粗体
    var bold: UIFont { get }
}

extension LabFontUtils {
    
    func font(type: LabFontType) -> UIFont {
        
        /// 字体大小
        var size: CGFloat = 1

        switch self {
        
        case let floatFontSize as Float:
            
            size = CGFloat(floatFontSize)

        case let intFontSize as Int:
            
            size = CGFloat(intFontSize)
        case let fontSize as Double:
            
            size = CGFloat(fontSize)
        default:
            break
        }
        
        func _normalFont() -> () -> UIFont {

            return { return UIFont.iconFont(size) }
        }

        func _mediuFont() -> () -> UIFont {
            
            return { return UIFont.systemFont(ofSize: size, weight: .medium) }
        }

        func _boldFont() -> () -> UIFont {

            return { return UIFont.systemFont(ofSize: size, weight: .bold) }
        }
        
        func _fontType() -> UIFont {
            
            switch type {
            case .medium:
                
                return _mediuFont()()
            case .bold:
                
                return _boldFont()()
            default:
                
                return _normalFont()()
            }
        }
        
        return _fontType()
    }
    
    /// 字体
    var font: UIFont { return font(type: .default) }
    
    /// 中体
    var medium: UIFont { return font(type: .medium) }
    
    /// 粗体
    var bold: UIFont { return font(type: .bold) }
}


extension Float: LabFontUtils {}

extension Int: LabFontUtils {}

extension Double: LabFontUtils {}


extension LabFontUtils where Self == String {
    
    var font: UIFont {

        return UIFont.systemFont(ofSize: CGFloat(Float(self) ?? 1))
    }
    
    var mediumFont: UIFont {

        return UIFont.systemFont(ofSize: CGFloat(Float(self) ?? 1))
    }
    
    var boldFont: UIFont {

        return UIFont.systemFont(ofSize: CGFloat(Float(self) ?? 1))
    }
}

extension String: LabFontUtils {}
