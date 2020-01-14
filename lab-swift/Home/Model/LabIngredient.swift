//
//  LabIngredient.swift
//  lab-swift
//
//  Created by q huang on 2020/1/14.
//  Copyright © 2020 qeeniao35. All rights reserved.
//

import UIKit
import IGListDiffKit

class LabIngredient: NSObject, ListDiffable {
    
    
    
    // MARK: - ListDiffable
    func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return true
    }
}
