//
//  WanderImageManager.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 huang q. All rights reserved.
//

import Foundation
import Photos
import UIKit

let WanderManager = WanderImageManager.default

let WanderConfiguration = WanderImageConfiguration.default


/// 资源管理配置参数
class WanderImageConfiguration {
    /// 单例对象
    static let `default` = WanderImageConfiguration()
    
    /// 预览照片的图片的大小
    var estimatedPreviewPhotoSize: CGSize = CGSize(width: 80, height: 80)
    
    /// 照片显示排列列数
    var estimatedImageDisplayColumn: Int = 3
    
    /// 是否想显示从icloud上下载进度
    var iCloudProgress: Bool = false
    
    /// 是否允许使用视频资源
    var allowVideoAssets: Bool = false
    
    /// 是否使用图片资源[暂时没增加逻辑]
    var allowImageAssets: Bool = true
    
    /// 是否使用摄像头，允许拍照
    var allowCameraComponents: Bool = false
    
    /// 图片优先模糊展示
    var allowImageDegrade: Bool = true
    
    /// 允许图片动态展示
    var allowGifImageDisplay: Bool = false
    
    /// 是否多选数据
    var allowMultipleSelectAsset: Bool = false
    
    private init() {}
}


/// 图片资源文件管理
class WanderImageManager {
    /// 单例对象
    static let `default` = WanderImageManager()

    private lazy var queue: DispatchQueue = {

        let queue = DispatchQueue(label: "com.daodao.ziguhonglan.queue.image_manager")
        
        return queue
    }()
    
    private lazy var group: DispatchGroup = {

        let group = DispatchGroup()

        return group
    }()
    

    // MARK: - method 方法
    private init() {}
    
    
    // MARK: 权限获取
    /// 是否取得授权，如果没有授权，唤起授权动作
    /// - Returns: 授权与否
    class func authorizationStatusAuthorized() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .notDetermined:
            requestAuthorizationWithCompletion {}
            break
        default: break
        }
        
        return status == .authorized
        
    }
    
    /// 请求授权回调
    /// - Parameter completion: 回调方法
    class func requestAuthorizationWithCompletion(completion: @escaping () -> Void) {
        DispatchQueue.global().async {

            PHPhotoLibrary.requestAuthorization { (status) in

                DispatchQueue.main.async {

                    completion()
                }
            }
        }
    }
    
    
    // MARK: 相簿

    /// 抓取相对应的相册资源文件
    /// - Parameter completion: 回调方法
    class func fetchAlbumResources(_ completion : @escaping (_ albums: Array<WanderAlbumModel>) -> Void) {

        guard authorizationStatusAuthorized() else {
            return
        }
        
        var albumArrays: [WanderAlbumModel] = []
        
        var customAlbumArray: [WanderAlbumModel] = []
        
        let options = PHFetchOptions()

        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        var allAlbumModel: WanderAlbumModel?

        // `全部照片`
        WanderManager.group.enter()

        WanderManager.queue.async(group: WanderManager.group) {

            let result = PHAsset.fetchAssets(with: .image, options: options)

            let collection = PHAssetCollection.transientAssetCollection(withAssetFetchResult: result, title: "全部照片")

            allAlbumModel = initialAlbumModel(result, collection: collection, options: options)

            WanderManager.group.leave()
        }
        
        // 遍历循环照片
        WanderManager.group.enter()

        WanderManager.queue.async(group: WanderManager.group) {
            
            let systemCollectionResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)

            systemCollectionResult.enumerateObjects { (collection, index, nil) in

                if collection.assetCollectionSubtype == .smartAlbumVideos
                    || collection.assetCollectionSubtype == .smartAlbumAllHidden
                    || collection.assetCollectionSubtype == .smartAlbumLivePhotos
                    || collection.assetCollectionSubtype == PHAssetCollectionSubtype(rawValue: 1000000201) {
                    // 隐藏，连拍快照，最近删除 不显示
                    return
                }

                // 视频
                if !WanderConfiguration.allowVideoAssets && collection.assetCollectionSubtype == .smartAlbumVideos {
                    return
                }

                let result = PHAsset.fetchAssets(in: collection, options: options)
                
                guard result.count > 0 else { return }
                
                let albumModel = initialAlbumModel(result, collection: collection, options: options)

                albumArrays.append(albumModel)
            }
            
            WanderManager.group.leave()
        }

        // 自定义
        WanderManager.group.enter()

        WanderManager.queue.async(group: WanderManager.group) {
            
            let customCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)

            customCollectionResult.enumerateObjects { (collection, index, nil) in

                if collection.assetCollectionSubtype == .smartAlbumVideos
                    || collection.assetCollectionSubtype == .smartAlbumAllHidden
                    || collection.assetCollectionSubtype == .smartAlbumLivePhotos
                    || collection.assetCollectionSubtype == PHAssetCollectionSubtype(rawValue: 1000000201) {
                    // 隐藏，连拍快照，最近删除 不显示
                    return
                }

                // 视频
                if !WanderConfiguration.allowVideoAssets && collection.assetCollectionSubtype == .smartAlbumVideos {
                    return
                }

                let result = PHAsset.fetchAssets(in: collection, options: nil)
                
                guard result.count > 0 else { return }
                
                let albumModel = initialAlbumModel(result, collection: collection, options: options)

                customAlbumArray.append(albumModel)
            }

            WanderManager.group.leave()
        }
        
        WanderManager.group.notify(queue: DispatchQueue.main) {
            
            if let allIncludeAlbumModel = allAlbumModel {

                albumArrays.insert(allIncludeAlbumModel, at: 0)

            }
            
            albumArrays += customAlbumArray

            completion(albumArrays)
        }
    }
    
    /// 初始化一个相簿资源文件
    /// - Parameters:
    ///   - result: 照片查询结果
    ///   - collection: 相簿资源集合
    ///   - options: 参数设置
    /// - Returns: 相簿资源对象
    class func initialAlbumModel(_ result: PHFetchResult<PHAsset>, collection: PHAssetCollection, options: PHFetchOptions?) -> WanderAlbumModel {

        let albumModel = WanderAlbumModel()

        albumModel.result = result

        albumModel.collection = collection
        
        albumModel.options = options
        
        albumModel.count = result.count
        
        albumModel.name = collection.localizedTitle

        return albumModel
    }
    

    // MARK: 图片资源

    /// 获取资源PHAsset数据
    /// - Parameters:
    ///   - result: 照片资源数据
    ///   - completion: 回调方法
    class func fetchPhotoAssetsResources(_ result: PHFetchResult<PHAsset>, completion: @escaping ([WanderPhotoAssetModel]) -> Void) {

        var assets: [WanderPhotoAssetModel] = []
        
        result.enumerateObjects { (asset, index, nil) in
            
            let mediaType = asset.getAssetInfo()
            
            if !WanderConfiguration.allowVideoAssets && mediaType != .image && mediaType != .gif {
                return
            }
            
            let assetModel = WanderPhotoAssetModel()

            assetModel.asset = asset
            
            assetModel.mediaType = mediaType
            
            assetModel.representAssetIdentifier = asset.localIdentifier
            
            assets.append(assetModel)
        }

        completion(assets)
    }
    
    /// 获取预估大小的照片[照片大小不一定是预估的大小]
    /// - Parameters:
    ///   - asset: 图片资源
    ///   - estimatedSize: 预估大小
    ///   - completion: 回调方法
    /// - Returns: 请求的id
    class func getPhotoImage(_ asset: PHAsset, estimatedSize: CGSize = CGSize(width: 80, height: 80), progressHandler: @escaping (Double, Error?) -> Void, completion: @escaping (UIImage?, [AnyHashable:Any]?, Bool) -> Void) -> PHImageRequestID {
        
        let aspectRatio = CGFloat(asset.pixelWidth / asset.pixelHeight)

        var pixelWidth = estimatedSize.width
        
        if aspectRatio > 1.7 {
            pixelWidth *= aspectRatio
        }
        
        if aspectRatio < 0.2 {
            pixelWidth *= 0.5
        }
        
        let scale = UIScreen.main.scale
        
        let pixelHeight = CGFloat(pixelWidth / aspectRatio) * UIScreen.main.scale
        
        let option = PHImageRequestOptions()
        
        option.isNetworkAccessAllowed = true
        
        option.resizeMode = .fast
        
        option.progressHandler = {(progress, error, stop, info) in

            guard WanderConfiguration.iCloudProgress else { return }

            DispatchQueue.main.async {
                
                progressHandler(progress, error)
            }
        }
        
        let requestId = PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixelWidth * scale, height: pixelHeight * scale), contentMode: .aspectFill, options: option) { (image, info) in
            
            let isDegrade = info?[PHImageResultIsDegradedKey] as? Bool
            
            guard let cancelled = info?[PHImageCancelledKey] else {

                if image != nil {

                    DispatchQueue.main.async {

                        completion(image, info, isDegrade ?? false)
                    }
                }
                return
            }
            
            guard cancelled as! Bool else {
                
                DispatchQueue.main.async {
                    
                    completion(image, info, isDegrade ?? false)
                }
                return
            }
        }
        
        return requestId
    }
    
    /// 获取原始图片资源
    /// - Parameters:
    ///   - asset: 图片资源
    ///   - progressHandler: iCloud下载进度
    ///   - completion: 完成回调
    /// - Returns: 返回的请求id
    class func getOriginImage(_ asset: PHAsset, progressHandler: @escaping (Double, Error?) -> Void, completion: @escaping (Data, [AnyHashable:Any]?) -> Void) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        
        option.isNetworkAccessAllowed = true
        
        option.resizeMode = .fast
        
        option.progressHandler = {(progress, error, stop, info) in

            guard WanderConfiguration.iCloudProgress else { return }

            DispatchQueue.main.async {
                
                progressHandler(progress, error)
            }
        }
        
        return PHImageManager.default().requestImageDataAndOrientation(for: asset, options: option) { (data, dataUTI, orientation, info) in
            
            guard let imageData = data else { return }
            
            var renderImageData = imageData
            
            if orientation != .up {
                
                let image = UIImage(data: renderImageData)!
                
                renderImageData = image.jpegData(compressionQuality: 1)!
            }
            
            guard let cancelled = info?[PHImageCancelledKey] else {
                
                DispatchQueue.main.async {
                    
                    completion(renderImageData, info)
                }
                return
            }
            
            guard cancelled as! Bool else {
                DispatchQueue.main.async {
                    
                    completion(renderImageData, info)
                }
                
                return
            }
        }
    }
}


// MARK: - extension

extension PHAsset {

    func getAssetInfo() -> WanderPHAssetMediaType {
        
        switch mediaType {

        case .video:

            return .video

        case .audio:

            return .audio

        case .image:

            guard let fileName = value(forKeyPath: "filename") as? String,
                  fileName.uppercased().hasSuffix("GIF")
            else {
                return .image
            }
            
            return .gif

        default: break
        }
        
        return .unknown
    }
}
