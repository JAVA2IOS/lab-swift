//
//  WanderPhotoAssetModel.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 huang q. All rights reserved.
//

import Foundation

import UIKit

import Photos

enum WanderPHAssetMediaType: Int {
    case unknown = 0
    case gif = 1
    case image = 2
    case video = 3
    case audio = 4
}

let WanderPHImageRequestNone: PHImageRequestID = -999

/// 照片资源文件管理
class WanderPhotoAssetModel {
    /// 资源类型
    var mediaType: WanderPHAssetMediaType = .unknown
    
    /// 资源数据
    var asset: PHAsset?
    
    /// 预览照片请求接口的id
    var previewImageRequestID: PHImageRequestID = WanderPHImageRequestNone
    
    /// 原图照片请求接口id
    var originImageRequestID: PHImageRequestID = WanderPHImageRequestNone
    
    /// PHAsset的唯一性标志符
    var representAssetIdentifier: String?
    
    /// 预览图片资源
    var previewImage: UIImage?
}
