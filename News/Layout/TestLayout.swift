//
//  TestLayout.swift
//  News
//
//  Created by Dzmitry Bosak on 9/26/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

enum MosaicStyle {
    case fiftyFifty
    case twoHalvesOneHalf
    case oneHalfTwoHalves
}

class TestLayout: UICollectionViewFlowLayout {

    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func prepare() {
        
        guard let collectionView = collectionView else { return }
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        let count = collectionView.numberOfItems(inSection: 0)

    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
}
