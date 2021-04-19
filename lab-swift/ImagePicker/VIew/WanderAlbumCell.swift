//
//  WanderAlbumCell.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 haung q. All rights reserved.
//

import UIKit

extension UITableViewCell {
    class func wander_reusableIdentifier() -> String {
        return "wander_table_cell_reusable_identifier_" + NSStringFromClass(self)
    }
}

class WanderAlbumCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        _initialComponentsUI()
    }

    
    // MARK: - Data
    private func _initialComponentsDatas() {}
    
    
    // MARK: - UI
    private func _initialComponentsUI() {

        contentView.addSubview(albumImageView)

        contentView.addSubview(albumLabel)
        
        let imageHeightLayout = NSLayoutConstraint(item: albumImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)

        let imageWidthLayout = NSLayoutConstraint(item: albumImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        
        let imageLeftLayout = NSLayoutConstraint(item: albumImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 15)
        
        let imageCenterYLayout = NSLayoutConstraint(item: albumImageView, attribute: .centerY, relatedBy: .equal, toItem: contentView, attribute: .centerY, multiplier: 1, constant: 0)

        
        let lableTopLayout = NSLayoutConstraint(item: albumLabel, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        
        let labelLeftLayout = NSLayoutConstraint(item: albumLabel, attribute: .leading, relatedBy: .equal, toItem: albumImageView, attribute: .trailing, multiplier: 1, constant: 10)
        
        let labelRightLayout = NSLayoutConstraint(item: albumLabel, attribute: .trailing, relatedBy: .lessThanOrEqual, toItem: contentView, attribute: .trailing, multiplier: 1, constant: -15)
        
        let labelBottomLayout = NSLayoutConstraint(item: albumLabel, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        contentView.addConstraints([imageHeightLayout, imageWidthLayout, imageLeftLayout, imageCenterYLayout])

        contentView.addConstraints([lableTopLayout, labelLeftLayout, labelRightLayout, labelBottomLayout])
    }
    
    
    // MARK: - Logic
    
    
    // MARK: - setter & getter
    
    var albumModel: WanderAlbumModel? {
        didSet {

            albumLabel.text = albumModel?.name
        }
    }
    

    /// 相簿预览图片
    private lazy var albumImageView: UIImageView = {

        let albumImageView = UIImageView()
        
        albumImageView.backgroundColor = .gray
        
        albumImageView.layer.cornerRadius = 4
        
        albumImageView.translatesAutoresizingMaskIntoConstraints = false

        return albumImageView
    }()
    
    /// 相簿名称
    private lazy var albumLabel: UILabel = {

        let albumLabel = UILabel()
        
        albumLabel.font = UIFont.systemFont(ofSize: 12)
        
        albumLabel.textColor = .black
        
        albumLabel.translatesAutoresizingMaskIntoConstraints = false

        return albumLabel
    }()


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
