//
//  WanderPhotoCell.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 haung q. All rights reserved.
//

import UIKit

import Photos

extension UICollectionViewCell {
    class func wander_reusableIdentifier() -> String {
        return "wander_collection_cell_reusable_identifier_" + NSStringFromClass(self)
    }
}

extension UICollectionView {
    func wander_regist(_ cClass: UICollectionViewCell.Type) {
        register(cClass, forCellWithReuseIdentifier: cClass.wander_reusableIdentifier())
    }
}

class WanderPhotoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)

        _initialComponentsUI()
    }
    
    // MARK: - UI
    private func _initialComponentsUI() {
        contentView.addSubview(photoImageView)
        
        let imageTopLayout = NSLayoutConstraint(item: photoImageView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        
        let imageBottomLayout = NSLayoutConstraint(item: photoImageView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0)
        
        let imageLeftLayout = NSLayoutConstraint(item: photoImageView, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: 0)
        
        let imageRightLayout = NSLayoutConstraint(item: photoImageView, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0)
        
        contentView.addConstraints([imageTopLayout, imageBottomLayout, imageLeftLayout, imageRightLayout])
    }
    
    // MARK: - Data
    private func _initialComponentsDatas() {}
    
    
    // MARK: - Logic
    
    
    // MARK: - setter & getter
    
    var assetModel: WanderPhotoAssetModel? {
        didSet {
            guard let newModel = assetModel else { return }
            
            assetIdentifier = newModel.representAssetIdentifier
            
            guard let image = newModel.previewImage else {
                
                let requestID = WanderImageManager.getPhotoImage(newModel.asset!, estimatedSize: WanderConfiguration.estimatedPreviewPhotoSize, progressHandler: { (_, _) in }) { (image, info, isDegrade) in

                    guard self.assetIdentifier == newModel.representAssetIdentifier && self.requestIdentifier != WanderPHImageRequestNone else {

                        self.photoImageView.image = nil

                        PHImageManager.default().cancelImageRequest(self.requestIdentifier)

                        return
                    }
                    
                    if !isDegrade {

                        self.requestIdentifier = WanderPHImageRequestNone
                    
                        self.photoImageView.image = image
                        
                        newModel.previewImage = image
                    }
                    
                    if WanderConfiguration.allowImageDegrade {
                        self.photoImageView.image = image
                    }
                }

                newModel.previewImageRequestID = requestID

                if requestIdentifier != requestID && requestIdentifier != WanderPHImageRequestNone {

                    PHImageManager.default().cancelImageRequest(requestIdentifier)
                }
                
                requestIdentifier = requestID

                return
            }

            self.photoImageView.image = image
            
            guard requestIdentifier == WanderPHImageRequestNone else {
                
                PHImageManager.default().cancelImageRequest(requestIdentifier)
                
                requestIdentifier = WanderPHImageRequestNone

                return
            }
        }
    }
    
    /// 资源的唯一标志符
    private var assetIdentifier: String?
    
    /// 请求图片的id
    private var requestIdentifier: PHImageRequestID = WanderPHImageRequestNone

    /// 相簿预览图片
    private lazy var photoImageView: UIImageView = {

        let albumImageView = UIImageView()
        
        albumImageView.backgroundColor = .lightGray
        
        albumImageView.layer.cornerRadius = 4
        
        albumImageView.translatesAutoresizingMaskIntoConstraints = false
        
        albumImageView.contentMode = .scaleAspectFill
        
        albumImageView.layer.masksToBounds = true

        return albumImageView
    }()

    
    // MARK: - others
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
