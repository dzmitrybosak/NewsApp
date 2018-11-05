//
//  MosaicLayout.swift
//  News
//
//  Created by Dzmitry Bosak on 9/7/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class MosaicLayout: UICollectionViewFlowLayout {
    
    private enum MosaicSegmentStyle {
        case oneBigTwoSmall
        case twoSmallOneBig
        case twoBig
        case fullWidth
    }
    
    private struct Constants {
        struct Item {
            static let width: CGFloat = 128.0
            static let height: CGFloat = 128.0
        }
        struct Container {
            static let spacing: CGFloat = 2.0
        }
    }
    
    private var contentBounds = CGRect.zero
    private var cachedAttributes = [UICollectionViewLayoutAttributes]()
    private var segmentRects = [CGRect]()
    
    // Prepare Layout
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        // Reset cached information.
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: collectionView.bounds.size)
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        
        let count = collectionView.numberOfItems(inSection: 0)
        var currentIndex = 0
        
        var lastFrame: CGRect = .zero
        let collectionViewWidth = collectionView.bounds.size.width
        
        var segment: MosaicSegmentStyle = .oneBigTwoSmall
        
        var availableNumberOfSegments: CGFloat {
            return collectionViewWidth / (segmentWidth + Constants.Container.spacing)
        }
        
        var segmentsWidth: CGFloat {
            return segmentWidth * availableNumberOfSegments.rounded(.down)
        }
        
        while currentIndex < count {
            
            segmentRects.removeAll()
            
            let xOffset: CGFloat = collectionView.bounds.minX
            let yOffset = lastFrame.maxY + Constants.Container.spacing
            
            // Calculate every segment style.
            switch segment {
            case .oneBigTwoSmall:
                
                var lastX = xOffset

                while lastX <= segmentsWidth {
                    segmentRects += calculateOneBigTwoSmallSegment(x: lastX, y: yOffset)
                    lastX += segmentWidth + Constants.Container.spacing
                }
                
            case .twoSmallOneBig:
                
                var lastX = xOffset
                
                while lastX <= segmentsWidth {
                    segmentRects += calculateTwoSmallOneBigSegment(x: lastX, y: yOffset)
                    lastX += segmentWidth + Constants.Container.spacing
                }
                
            case .twoBig:
                segmentRects = calculateTwoBigSegment(x: xOffset, y: yOffset)
                
            case .fullWidth:
                segmentRects = calculateFullWidthSegment(x: xOffset, y: yOffset)
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
            changeSegmentStyle(numberOfItemsInCollectionView: count, index: currentIndex, segment: &segment)
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

// MARK: - Calculation properties and methods

extension MosaicLayout {
    
    // MARK: - Calculated properties
    
    private var segmentWidth: CGFloat {
        return Constants.Item.width + Constants.Container.spacing + Constants.Item.width
    }
    
    private var smallItemHeight: CGFloat {
        return (Constants.Item.height - Constants.Container.spacing) / 2
    }
    
    // MARK: - Methods which calculate every segment style
    
    private func calculateFullWidthSegment(x: CGFloat, y: CGFloat) -> [CGRect] {
        let itemFrame = CGRect(x: x, y: y, width: Constants.Item.width + Constants.Container.spacing + Constants.Item.width , height: Constants.Item.height)
        return [itemFrame]
    }
    
    private func calculateTwoBigSegment(x: CGFloat, y: CGFloat) -> [CGRect] {
        
        let firstItem = CGRect(x: x, y: y, width: Constants.Item.width, height: Constants.Item.height)
        let secondItem = CGRect(x: firstItem.maxX + Constants.Container.spacing, y: y, width: Constants.Item.width, height: Constants.Item.height)
        
        return [firstItem, secondItem]
    }
    
    private func calculateOneBigTwoSmallSegment(x: CGFloat, y: CGFloat) -> [CGRect] {
        
        let leftBigItem = CGRect(x: x, y: y, width: Constants.Item.width, height: Constants.Item.height)
        let topSmallItem = CGRect(x: leftBigItem.maxX + Constants.Container.spacing, y: y, width: Constants.Item.width, height: smallItemHeight)
        let bottomSmallItem = CGRect(x: leftBigItem.maxX + Constants.Container.spacing, y: topSmallItem.maxY + Constants.Container.spacing, width: Constants.Item.width, height: smallItemHeight)
        
        return [leftBigItem, topSmallItem, bottomSmallItem]
    }
    
    private func calculateTwoSmallOneBigSegment(x: CGFloat, y: CGFloat) -> [CGRect] {
        
        let topSmallItem = CGRect(x: x, y: y, width: Constants.Item.width, height: smallItemHeight)
        let bottomSmallItem = CGRect(x: x, y: topSmallItem.maxY + Constants.Container.spacing, width: Constants.Item.width, height: smallItemHeight)
        let rightBigItem = CGRect(x: topSmallItem.maxX + Constants.Container.spacing, y: y, width: Constants.Item.width, height: Constants.Item.height)
        
        return [topSmallItem, bottomSmallItem, rightBigItem]
    }
    
    // Determine the next segment style.
    private func changeSegmentStyle(numberOfItemsInCollectionView: Int, index: Int, segment: inout MosaicSegmentStyle) {
        switch numberOfItemsInCollectionView - index {
        case 1:
            segment = .fullWidth
        case 2:
            segment = .twoBig
        default:
            switch segment {
            case .oneBigTwoSmall:
                segment = .twoSmallOneBig
            case .twoSmallOneBig:
                segment = .oneBigTwoSmall
            case .twoBig:
                segment = .fullWidth
            case .fullWidth:
                segment = .oneBigTwoSmall
            }
        }
    }
}
