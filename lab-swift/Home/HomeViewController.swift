//
//  HomeViewController.swift
//  lab-swift
//
//  Created by q huang on 2020/1/7.
//  Copyright © 2020 qeeniao35. All rights reserved.
//

import UIKit
import IGListKit

class HomeViewController: GenericController, ListAdapterDataSource {
    var collection : ListCollectionView!
    var adapter : ListAdapter!
    var data : [LabIngredient]!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViewComponents()
        initilizeData()
    }
    
    // MARK: - Data
    private func initilizeData() {
        data = [LabIngredient()]
        adapter = ListAdapter(updater: ListAdapterUpdater(), viewController: self)
        adapter.collectionView = collection
        adapter.dataSource = self
    }
    
    // MARK: - UI
    private func addSubViewComponents() {
        
        labNavBar.navbarTitle = "首页"
        
        // iconfont 矢量图标
        let iconLabel = UILabel(frame: CGRect(x: 20, y: labNavBar.frame.maxY, width: 100, height: 50))
        
        iconLabel.textAlignment = .center
        
        iconLabel.iconFont(name: "\u{e7d4} \u{e7d5}", size: 25)
        
        iconLabel.textColor = "#51c4d3".color
        
        iconLabel.sizeToFit()
        
        view.addSubview(iconLabel)
        
        let layout = ListCollectionViewLayout(stickyHeaders: true, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: false)
        
        collection = ListCollectionView(frame: CGRect(origin: CGPoint(x: 0, y: 180), size: CGSize(width: view.frame.size.width, height: view.frame.size.height - 180)), listCollectionViewLayout: layout)
        collection.backgroundColor = .white

        view.addSubview(collection)
    }
    
    
    // MARK: - Delegate
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSectionController()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return LabEmptyView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
