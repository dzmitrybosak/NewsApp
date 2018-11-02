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
        
        let collectionViewWidth = collectionView.bounds.size.width
        
        while currentIndex < count {
            
            var segmentRects = [CGRect]()
            
            let spacing: CGFloat = 2.0
            let numberOfRects: CGFloat = 2
            
            let itemWidth: CGFloat = 160.0
            let itemHeight: CGFloat = 160.0
                        
            var xOffset: CGFloat {
                
                if collectionViewWidth >= (itemWidth + spacing) * 4 {
                    return (collectionViewWidth / 2) - (itemWidth * 2)
                } else {
                    return (collectionViewWidth / 2) - itemWidth
                }
                
            }
            
            let yOffset: CGFloat = lastFrame.maxY + (spacing * 2)
            
            switch segment {
            case .fullWidth:
                
                let segmentFrame = CGRect(x: xOffset, y: yOffset, width: itemWidth * 2, height: itemHeight)
                segmentRects = [segmentFrame]
                
            case .fiftyFifty:
                
                let halfFirst = CGRect(x: xOffset, y: yOffset, width: itemWidth - spacing, height: itemHeight)
                let halfSecond = CGRect(x: xOffset + itemWidth + spacing, y: yOffset, width: itemWidth - spacing, height: itemHeight)
                
                segmentRects = [halfFirst, halfSecond]
                
                if collectionViewWidth >= (itemWidth + spacing) * 4 {
                    let halfThird = CGRect(x: xOffset, y: yOffset, width: (itemWidth * 2) - spacing, height: itemHeight)
                    let halfFourth = CGRect(x: xOffset + (itemWidth * 2) + spacing, y: yOffset, width: (itemWidth * 2) - spacing, height: itemHeight)

                    segmentRects = [halfThird, halfFourth]
                }
            
            case .twoThirdsOneThird:
                
                let leftThirdInTwoThirdsOneThird = CGRect(x: xOffset, y: yOffset, width: itemWidth - spacing, height: itemHeight)
                let rightThirdFirstInTwoThirdsOneThird = CGRect(x: xOffset + itemWidth + spacing, y: yOffset, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                let rightThirdSecondInTwoThirdsOneThird = CGRect(x: xOffset + itemWidth + spacing, y: yOffset + (itemHeight / numberOfRects) + spacing, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                
                segmentRects = [leftThirdInTwoThirdsOneThird, rightThirdFirstInTwoThirdsOneThird, rightThirdSecondInTwoThirdsOneThird]
                
                if collectionViewWidth >= (itemWidth + spacing) * 4 {
                    let leftThirdInTwoThirdsOneThirdExtra = CGRect(x: xOffset + ((itemWidth + spacing) * 2), y: yOffset, width: itemWidth - spacing, height: itemHeight)
                    let rightThirdFirstInTwoThirdsOneThirdExtra = CGRect(x: xOffset + ((itemWidth + spacing) * 3), y: yOffset, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                    let rightThirdSecondInTwoThirdsOneThirdExtra = CGRect(x: xOffset + ((itemWidth + spacing) * 3), y: yOffset + (itemHeight / numberOfRects) + spacing, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)

                    segmentRects += [leftThirdInTwoThirdsOneThirdExtra, rightThirdFirstInTwoThirdsOneThirdExtra, rightThirdSecondInTwoThirdsOneThirdExtra]
                }
                
            case .oneThirdTwoThirds:
                
                let leftThirdFirstInOneThirdTwoThirds = CGRect(x: xOffset, y: yOffset, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                let leftThirdSecondInOneThirdTwoThirds = CGRect(x: xOffset, y: yOffset + (itemHeight / numberOfRects) + spacing, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                let rightThirdInOneThirdTwoThirds = CGRect(x: xOffset + itemWidth + spacing, y: yOffset, width: itemWidth - spacing, height: itemHeight)
                
                segmentRects = [leftThirdFirstInOneThirdTwoThirds, leftThirdSecondInOneThirdTwoThirds, rightThirdInOneThirdTwoThirds]
                
                if collectionViewWidth >= (itemWidth + spacing) * 4 {
                    let leftThirdFirstInOneThirdTwoThirdsExtra = CGRect(x: xOffset + ((itemWidth + spacing) * 2), y: yOffset, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                    let leftThirdSecondInOneThirdTwoThirdsExtra = CGRect(x: xOffset + ((itemWidth + spacing) * 2), y: yOffset + (itemHeight / numberOfRects) + spacing, width: itemWidth - spacing, height: (itemHeight / numberOfRects) - spacing)
                    let rightThirdInOneThirdTwoThirdsExtra = CGRect(x: xOffset + ((itemWidth + spacing) * 3), y: yOffset, width: itemWidth - spacing, height: itemHeight)

                    segmentRects += [leftThirdFirstInOneThirdTwoThirdsExtra, leftThirdSecondInOneThirdTwoThirdsExtra, rightThirdInOneThirdTwoThirdsExtra]
                }
            }
            
            // Create and cache layout attributes for calculated frames.
            for rect in segmentRects {
                let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPath(item: currentIndex, section: 0))
                attributes.frame = rect
                
                cachedAttributes.append(attributes)
                contentBounds = contentBounds.union(lastFrame)
                
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
