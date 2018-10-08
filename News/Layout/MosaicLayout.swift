//
//  MosaicLayout.swift
//  News
//
//  Created by Dzmitry Bosak on 9/7/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

enum MosaicSegmentStyle {
    case twoThirdsOneThird
    case oneThirdTwoThirds
    case fiftyFifty
    case fullWidth
}

class MosaicLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    // PrepareMosaicLayout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else { return }
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        let count = collectionView.numberOfItems(inSection: 0)
        
        var currentIndex = 0
        var segment: MosaicSegmentStyle = .twoThirdsOneThird
        var lastFrame: CGRect = .zero
        
        let cvWidth = collectionView.bounds.size.width
        
        while currentIndex < count {
            
            var segmentRects = [CGRect]()
            
            switch segment {
            case .fullWidth:
                
                let segmentFrame = CGRect(x: 0, y: lastFrame.maxY + 2.0, width: cvWidth, height: 200.0)
                segmentRects = [segmentFrame]
                
            case .fiftyFifty:
                
                let space: CGFloat = 2.0
                let x: CGFloat = 0
                let y: CGFloat = lastFrame.maxY + (space * 2)
                let numberOfRects: CGFloat = 2
                let width: CGFloat = cvWidth / numberOfRects
                let heigt: CGFloat = 200.0
                
                let halfFirst = CGRect(x: x, y: y, width: width - space, height: heigt)
                let halfSecond = CGRect(x: x + width + space, y: y, width: width - space, height: heigt)
                
                segmentRects = [halfFirst, halfSecond]
                
            case .twoThirdsOneThird:
                
                let space: CGFloat = 2.0
                let x: CGFloat = 0
                let y: CGFloat = lastFrame.maxY + (space * 2)
                let numberOfRects: CGFloat = 2
                let width: CGFloat = cvWidth / numberOfRects
                let heigt: CGFloat = 200.0
                
                let leftThird = CGRect(x: x, y: y, width: width - space, height: heigt)
                let rightThirdFirst = CGRect(x: x + width + space, y: y, width: width - space, height: (heigt / numberOfRects) - space)
                let rightThirdSecond = CGRect(x: x + width + space, y: y + (heigt / numberOfRects) + space, width: width - space, height: (heigt / numberOfRects) - space)
                
                segmentRects = [leftThird, rightThirdFirst, rightThirdSecond]
                
            case .oneThirdTwoThirds:
                
                let space: CGFloat = 2.0
                let x: CGFloat = 0
                let y: CGFloat = lastFrame.maxY + (space * 2)
                let numberOfRects: CGFloat = 2
                let width: CGFloat = cvWidth / numberOfRects
                let heigt: CGFloat = 200.0
                
                let leftThirdFirst = CGRect(x: x, y: y, width: width - space, height: (heigt / numberOfRects) - space)
                let leftThirdSecond = CGRect(x: x, y: y + (heigt / numberOfRects) + space, width: width - space, height: (heigt / numberOfRects) - space)
                let rightThird = CGRect(x: x + width + space, y: y, width: width - space, height: heigt)
                
                segmentRects = [leftThirdFirst, leftThirdSecond, rightThird]
            }
            
            // Create and cache layout attributes for calculated frames.
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame) // возвращает наименьший rect
                
                currentIndex += 1
                lastFrame = rect
            }
            
            // Determine the next segment style.
            switch count - currentIndex {
            case 1:
                segment = .fullWidth
            case 2:
                segment = .fiftyFifty
            default:
                switch segment {
                case .twoThirdsOneThird:
                    segment = .oneThirdTwoThirds
                case .oneThirdTwoThirds:
                    segment = .twoThirdsOneThird
                case .fiftyFifty:
                    segment = .fullWidth
                case .fullWidth:
                    segment = .twoThirdsOneThird
                }
            }
        }
    }
    
    // CollectionViewContentSize
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    // ShouldInvalidateLayout
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    // LayoutAttributesForElements
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        // Loop through the cache and look for items in the rect
        for attributes in cachedAttributes {
            if attributes.frame.intersects(rect) { // что значит пересекаются два прямоугольника? // то есть, если совпадают значения фрэйма с позицией прямоугольника?
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
