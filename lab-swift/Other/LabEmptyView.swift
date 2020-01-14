//
//  LabEmptyView.swift
//  lab-swift
//
//  Created by q huang on 2020/1/14.
//  Copyright © 2020 qeeniao35. All rights reserved.
//

import UIKit
import SnapKit

class LabEmptyView: UIView {
    
    private var imageView : UIImageView?
    private var contentLabel : UILabel?
    

    // MARK: - UI
    func initializeComponents() {
        imageView = UIImageView()
        addSubview(imageView!)
        imageView!.snp_makeConstraints({ (make) in
            make.left.equalTo(self)
            make.top.equalTo(self)
            make.height.equalTo(40)
            make.right.equalTo(self)
        })
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
