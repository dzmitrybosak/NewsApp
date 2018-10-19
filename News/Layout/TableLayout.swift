//
//  TableLayout.swift
//  News
//
//  Created by Dzmitry Bosak on 9/20/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class TableLayout: UICollectionViewFlowLayout {
 
    override func prepare() {
        super.prepare()
 
        guard let cv = collectionView else {
            return
        }
        
        let availableWidth = cv.bounds.inset(by: cv.layoutMargins).size.width
        
        let minColumnWidth = CGFloat(availableWidth / 2)
        let maxNumColumns = Int(availableWidth / minColumnWidth)
        let cellWidth = (availableWidth / CGFloat(maxNumColumns)).rounded(.down)
        
        itemSize = CGSize(width: cellWidth, height: 200.0)
        
        sectionInset = UIEdgeInsets(top: minimumInteritemSpacing, left: 0.0, bottom: 0.0, right: 0.0)
        sectionInsetReference = .fromSafeArea
    }
}
