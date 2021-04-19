//
//  WanderImagePickerController.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 huang q. All rights reserved.
//

import UIKit

class WanderImagePickerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        _initialComponentsUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collection.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let albumModel = albumModel,
              albumModel.result != nil,
              firstPush
        else {
            firstPush = false
            return
        }

        WanderImageManager.fetchPhotoAssetsResources(albumModel.result!) { (assetModels) in

            self.phototAssetModels = assetModels
            
            self.collection.reloadData()

        }
    }
    
    // MARK: - UI
    private func _initialComponentsUI() {
        
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(collection)
    }

    // MARK: - Data
    private func _initialComponentsDatas() {}


    // MARK: - Logic
    
    
    // MARK: - setter & getter
    
    /// 相簿对象
    var albumModel: WanderAlbumModel?
    
    /// 照片资源数据
    var phototAssetModels: [WanderPhotoAssetModel]?
    
    /// 是否第一次进入
    var firstPush: Bool = false
    
    /// 相册资源
    lazy var collection: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        
        let collection = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        
        collection.dataSource = self
        
        collection.delegate = self
        
        collection.showsVerticalScrollIndicator = false

        collection.contentInsetAdjustmentBehavior = .never
        
        collection.wander_regist(WanderPhotoCell.self)

        return collection
    }()
}


extension WanderImagePickerController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return phototAssetModels == nil ? 0 : phototAssetModels!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WanderPhotoCell.wander_reusableIdentifier(), for: indexPath) as! WanderPhotoCell

        cell.assetModel = phototAssetModels![indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (collectionView.frame.size.width - 10 * 4) / 3

        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let assetModel = phototAssetModels?[indexPath.row]
        
        guard assetModel?.previewImage != nil else { return }
        
        assetModel?.previewImage = nil
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
}

