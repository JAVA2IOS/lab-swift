//
//  WanderAlbumModel.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 huang q. All rights reserved.
//

import Foundation
import Photos
/// 相册/相簿资源
class WanderAlbumModel {
    /// 照片资源集合
    var collection: PHAssetCollection?

    /// 相册名称
    var name: String?
    
    /// 预估资源数量
    var count: Int = 0
    
    /// 图片资源
    var result: PHFetchResult<PHAsset>?
    
    /// 参数设置
    var options: PHFetchOptions?
    
    /// 照片数量
    var photoModels: [WanderPhotoAssetModel]?
}
