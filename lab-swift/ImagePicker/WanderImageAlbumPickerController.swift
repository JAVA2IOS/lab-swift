//
//  WanderImageAlbumPickerController.swift
//  lab-swift
//
//  Created by huangqing on 2021/1/8.
//  Copyright © 2021 haung q. All rights reserved.
//

import UIKit


class WanderImageAlbumPickerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        _initialComponentsUI()
        
        _initialComponentsDatas()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        albumTable.frame = view.bounds
    }
    
    // MARK: - Data
    private func _initialComponentsDatas() {
        
        WanderImageManager.fetchAlbumResources { (albumResources) in

            self.albumModels = albumResources
            
            self.albumTable.reloadData()
        }
    }
    
    
    // MARK: - UI
    private func _initialComponentsUI() {
        
        view.addSubview(albumTable)
    }
    
    
    // MARK: - Logic
    
    /// 重新加载选中的相簿
    func reloadSelectAlbum() {
        
        guard let currentAlbumModel = selectAlbumModel else { return }
        
        guard let albumArray = albumModels else { return }
        
        for (index, albumModel) in albumArray.enumerated() {

            if albumModel.collection!.assetCollectionType == currentAlbumModel.collection!.assetCollectionType
                && albumModel.collection!.assetCollectionSubtype == currentAlbumModel.collection!.assetCollectionSubtype
                && albumModel.collection!.localizedTitle == currentAlbumModel.collection!.localizedTitle {

                albumTable.selectRow(at: IndexPath(row: index, section: 0), animated: false, scrollPosition: .middle)
                break
            }
        }
        
    }
    
    
    // MARK: - setter & getter
    
    /// 相簿数据
    private var albumModels: [WanderAlbumModel]?
    
    /// 选中的相簿
    var selectAlbumModel: WanderAlbumModel?
    
    /// 相簿列表
    lazy var albumTable: UITableView = {

        let albumTable = UITableView()

        albumTable.dataSource = self

        albumTable.delegate = self
        
        albumTable.showsVerticalScrollIndicator = false
        
        albumTable.contentInsetAdjustmentBehavior = .never
        
        albumTable.estimatedRowHeight = 0
        
        albumTable.estimatedSectionHeaderHeight = 0

        albumTable.estimatedSectionFooterHeight = 0
        
        albumTable.separatorInset = UIEdgeInsets(top: 0, left: 70, bottom: 0, right: 18)
        
        albumTable.register(WanderAlbumCell.self, forCellReuseIdentifier: WanderAlbumCell.wander_reusableIdentifier())
        
        albumTable.tableFooterView = UIView()
        
        return albumTable
    }()
}


extension WanderImageAlbumPickerController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumModels == nil ? 0 : albumModels!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: WanderAlbumCell = tableView.dequeueReusableCell(withIdentifier: WanderAlbumCell.wander_reusableIdentifier()) as! WanderAlbumCell
        
        cell.albumModel = albumModels![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        selectAlbumModel = albumModels![indexPath.row]
        
        let imagePickerController = WanderImagePickerController()
        
        imagePickerController.albumModel = selectAlbumModel

        imagePickerController.firstPush = true

        imagePickerController.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(imagePickerController, animated: true)
    }
}

