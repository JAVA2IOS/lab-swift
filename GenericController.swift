//
//  GenericController.swift
//  lab-swift
//
//  Created by huangqing on 2021/4/7.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import UIKit

import Hue

class GenericController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(labNavBar)
        
        _initialComponentsUI()
    }

    // MARK: - UI
    private func _initialComponentsUI() {
        
        labNavBar.titleLabel.textColor = UIColor(hex: "000000")
        
        labNavBar.titleLabel.font = UIFont.iconFont(15)
        
        labNavBar.backgroundColor = .navbar
        
        labNavBar.snp.makeConstraints {
            
            $0.left.top.right.equalTo(self.view)
            
            $0.height.equalTo(44 + StaticStatusHeight)
        }
        
        view.layoutIfNeeded()
    }
    
    
    // MARK: - Logic
    
    /// 暗黑模式
    /// - Parameter previousTraitCollection: 暗黑模式改变
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {

        labNavBar.backgroundColor = .navbar
    }
    
    // MARK: - Data
    private func _initialComponentsDatas() {}
    
    
    // MARK: - setter & getter
    
    lazy var labNavBar: LabNavigationView = {

        let property = LabNavigationView()

        return property
    }()
}
