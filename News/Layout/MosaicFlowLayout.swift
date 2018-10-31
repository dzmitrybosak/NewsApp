//
//  MosaicFlowLayout.swift
//  News
//
//  Created by Dzmitry Bosak on 10/29/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

enum RectStyle {
    case bigItem
    case smallItems
}

class MosaicFlowLayout: UICollectionViewFlowLayout {
    
    private var contentBounds = CGRect.zero
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    private var bigIndexesArray: [Int] = []
    private var smallIndexesArray: [Int] = []
    
    // PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        bigIndexesArray.removeAll()
        smallIndexesArray.removeAll()
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        
        var rectStyle: RectStyle = .bigItem
        
        let itemWidth: CGFloat = 158.0
        let bigItemHeigh: CGFloat = 158.0
        let smallItemHeigh: CGFloat = 77.0
        
        let count = collectionView.numberOfItems(inSection: 0)
        var lastBigItemIndex = 0
        var currentIndex = 0
        
        var rects = [CGRect]()
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        while currentIndex < count {
            
            switch rectStyle {
            case .bigItem:
                itemSize = CGSize(width: itemWidth, height: bigItemHeigh)
                let rect = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                rects = [rect]
            case .smallItems:
                itemSize = CGSize(width: itemWidth, height: smallItemHeigh)
                let rectTop = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
                let rectBottom = CGRect(x: 0, y: 160, width: itemSize.width, height: itemSize.height)
                rects = [rectTop, rectBottom]
            }
            
            switch currentIndex {
            case 0:
                lastBigItemIndex = currentIndex
                bigIndexesArray.append(lastBigItemIndex)
                
            case lastBigItemIndex + 3:
                lastBigItemIndex = currentIndex
                bigIndexesArray.append(lastBigItemIndex)
                
            default:
                smallIndexesArray.append(currentIndex)
            }
            currentIndex += 1
            
            for rect in rects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                
                cachedAttributes.append(attributes)
                currentIndex += 1
            }
        }
        
        
        // присвоить атрибуты определенным индексам
        
        
        
//        for index in bigIndexesArray {
//
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
//            attributes.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
//
//            cachedAttributes.append(attributes)
//        }
//
//        for index in smallIndexesArray {
//
//            let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: index, section: 0))
//            attributes.frame = CGRect(x: 0, y: 0, width: itemSize.width, height: itemSize.height)
//
//            cachedAttributes.append(attributes)
//        }
        
        
    }
    
    // CollectionViewContentSize
//    override var collectionViewContentSize: CGSize {
//        return contentBounds.size
//    }
    
    // ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {
            return false
        }
        
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    // LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {

        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
    
    // LayoutAttributesForItem
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
}
