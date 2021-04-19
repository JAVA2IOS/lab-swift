//
//  LabNavigationView.swift
//  lab-swift
//
//  Created by huangqing on 2021/4/7.
//  Copyright © 2021 qeeniao35. All rights reserved.
//

import UIKit

import SnapKit

protocol LABNavigationProtocol {
    
    /// 内容距离容器的内边距
    var contentsEdgeInsets: UIEdgeInsets { get set }
    
    /// 返回导航按钮
    var leftNavBar: UIButton { get set }
    
    /// 右键按钮
    var rightNavBar: UIButton { get set }

    /// 导航标题
    var navbarTitle: String { get set }
    
    func leftNavbarItemResponder(_ button: UIButton)
    
    func rightNavbarItemResponder(_ button: UIButton)
}


class LabNavigationView: UIView, LABNavigationProtocol {
    
    var contentsEdgeInsets: UIEdgeInsets = .zero {
        didSet {

            layoutIfNeeded()
        }
    }

    var leftNavBar: UIButton
    
    var rightNavBar: UIButton
    
    var navbarTitle: String {

        didSet {
            
            titleLabel.text = navbarTitle
        }
    }
    
    @objc func leftNavbarItemResponder(_ button: UIButton) {}
    
    @objc func rightNavbarItemResponder(_ button: UIButton) {}
    
    override init(frame: CGRect) {

        leftNavBar = UIButton()
        
        navbarTitle = ""
        
        rightNavBar = UIButton()
        
        super.init(frame: frame)

        _initialComponentsUI()
    }
    
    // MARK: - UI
    private func _initialComponentsUI() {
        
        leftNavBar.addTarget(self, action: #selector(leftNavbarItemResponder(_:)), for: .touchUpInside)
        
        addSubview(leftNavBar)
        
        addSubview(titleLabel)
        
        titleLabel.text = navbarTitle
        
        rightNavBar.addTarget(self, action: #selector(rightNavbarItemResponder(_:)), for: .touchUpInside)
        
        addSubview(rightNavBar)
        
        // 返回键
        leftNavBar.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(44)
            $0.height.equalTo(44)
            $0.leftMargin.equalTo(contentsEdgeInsets.left)
            $0.bottom.equalTo(self)
        }
        
        // 标题栏
        titleLabel.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(0)
            $0.height.greaterThanOrEqualTo(0)
            $0.centerX.equalTo(self)
            $0.centerY.equalTo(leftNavBar)
        }
        
        // 右键
        rightNavBar.snp.makeConstraints {
            $0.width.greaterThanOrEqualTo(44)
            $0.height.equalTo(44)
            $0.rightMargin.equalTo(-contentsEdgeInsets.right)
            $0.bottom.equalTo(self)
        }
    }
    
    
    // MARK: - Logic
    
    // MARK: - Data
    private func _initialComponentsDatas() {}
    
    
    // MARK: - setter & getter
    
    /// 标题文本
    lazy var titleLabel: UILabel = {

        let property = UILabel()

        return property
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
