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
        case twoThirdsOneThird
        case oneThirdTwoThirds
        case fiftyFifty
        case fullWidth
    }
    
    private struct Constants {
        static let spacing: CGFloat = 2.0
        static let itemWidth: CGFloat = 160.0
        static let itemHeight: CGFloat = 160.0
        
        static let numberOfItemWidthsInSegment: CGFloat = 2
        static let numberOfSegmentForBigScreen: CGFloat = 2
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
        segmentRects.removeAll()
        
        // For every item in the collection view:
        //  - Prepare the attributes.
        //  - Store attributes in the cachedAttributes array.
        //  - Combine contentBounds with attributes.frame.
        
        let count = collectionView.numberOfItems(inSection: 0)
        var currentIndex = 0
        
        var lastFrame: CGRect = .zero
        let collectionViewWidth = collectionView.bounds.size.width
        
        var segment: MosaicSegmentStyle = .twoThirdsOneThird
        
        while currentIndex < count {
            
            var xOffset: CGFloat {
                let collectionViewWidthCenter = collectionView.bounds.midX
                
                if availableNumberOfSegmentsInCollectionView > 1 {
                    let offset = collectionView.bounds.minX
                    return offset
                } else {
                    let offset = collectionViewWidthCenter - Constants.itemWidth
                    return offset
                }
            }
            
            let yOffset = lastFrame.maxY + (Constants.spacing * 2)
            
            // Calculate every segment style.
            switch segment {
            case .fullWidth:
                calculateFullWidthSegment(x: xOffset, y: yOffset)
                
            case .fiftyFifty:
               calculateFiftyFiftySegment(x: xOffset, y: yOffset)
            
            case .twoThirdsOneThird:
                calculateTwoThirdsOneThirdSegment(x: xOffset, y: yOffset)
                
            case .oneThirdTwoThirds:
                calculateOneThirdTwoThirdsSegment(x: xOffset, y: yOffset)
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
    
    private var rectWidth: CGFloat {
        return (Constants.itemWidth * Constants.numberOfItemWidthsInSegment) + Constants.spacing
    }
    
    private var availableNumberOfSegmentsInCollectionView: CGFloat {
        
        guard let collectionView = collectionView else {
            return 0
        }
        
        let collectionViewWidth = collectionView.bounds.size.width
        let finalNumberOfSegmentsInCollectionView = collectionViewWidth / rectWidth
        
        return finalNumberOfSegmentsInCollectionView.rounded(.down)
    }
    
    private var numberOfItemsInTwoSegments: CGFloat {
        return Constants.numberOfItemWidthsInSegment * Constants.numberOfSegmentForBigScreen
    }
    
    private var dynamicItemWidth: CGFloat {
        
        guard let collectionView = collectionView else {
            return 0
        }
        
        let collectionViewWidth = collectionView.bounds.size.width
        let availableWidthOfSegmentInCollectionView = rectWidth * Constants.numberOfSegmentForBigScreen
        let emptySpace = collectionViewWidth - availableWidthOfSegmentInCollectionView
        let difference = emptySpace / numberOfItemsInTwoSegments
        let finalNewItemWidth = Constants.itemWidth + difference
        
        return finalNewItemWidth
    }
    
    private var calculatedItemWidth: CGFloat {
        if availableNumberOfSegmentsInCollectionView > 1 {
            return dynamicItemWidth - (Constants.spacing / numberOfItemsInTwoSegments)
        } else {
            return Constants.itemWidth - (Constants.spacing / Constants.numberOfItemWidthsInSegment)
        }
    }
    
    private var calculatedHeightForSmallItem: CGFloat {
        return (Constants.itemHeight / Constants.numberOfItemWidthsInSegment) - Constants.spacing
    }
    
    // Calculate every segment style.
    
    private func calculateFullWidthSegment(x: CGFloat, y: CGFloat) {
        
        let itemWidthForFullWidthSegment = (calculatedItemWidth * Constants.numberOfItemWidthsInSegment) + Constants.spacing
        let segmentFrame = CGRect(x: x, y: y, width: itemWidthForFullWidthSegment, height: Constants.itemHeight)
        
        segmentRects = [segmentFrame]
        
        if availableNumberOfSegmentsInCollectionView > 1 {

            let itemWidthForFullWidthSegmentExtra = ((calculatedItemWidth + Constants.spacing) * Constants.numberOfItemWidthsInSegment) * Constants.numberOfSegmentForBigScreen
            let segmentFrameExtra = CGRect(x: x, y: y, width: itemWidthForFullWidthSegmentExtra, height: Constants.itemHeight)

            segmentRects = [segmentFrameExtra]
        }
    }
    
    private func calculateFiftyFiftySegment(x: CGFloat, y: CGFloat) {
        
        let halfFirst = CGRect(x: x, y: y, width: calculatedItemWidth, height: Constants.itemHeight)
        let halfSecond = CGRect(x: halfFirst.maxX + Constants.spacing, y: y, width: Constants.itemWidth, height: Constants.itemHeight)
        
        segmentRects = [halfFirst, halfSecond]
        
        if availableNumberOfSegmentsInCollectionView > 1 {
            
            let halfFirstExtra = CGRect(x: x, y: y, width: (calculatedItemWidth * 2) + Constants.spacing, height: Constants.itemHeight)
            let halfSecondExtra = CGRect(x: halfFirstExtra.maxX + Constants.spacing, y: y, width: (calculatedItemWidth * 2) + Constants.spacing, height: Constants.itemHeight)
            
            segmentRects = [halfFirstExtra, halfSecondExtra]
        }
    }
    
    private func calculateTwoThirdsOneThirdSegment(x: CGFloat, y: CGFloat) {
        
        let leftThirdInTwoThirdsOneThird = CGRect(x: x, y: y, width: calculatedItemWidth, height: Constants.itemHeight - Constants.spacing)
        let rightThirdFirstInTwoThirdsOneThird = CGRect(x: leftThirdInTwoThirdsOneThird.maxX + Constants.spacing, y: y, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
        let rightThirdSecondInTwoThirdsOneThird = CGRect(x: leftThirdInTwoThirdsOneThird.maxX + Constants.spacing, y: rightThirdFirstInTwoThirdsOneThird.maxY + Constants.spacing, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
        
        segmentRects = [leftThirdInTwoThirdsOneThird, rightThirdFirstInTwoThirdsOneThird, rightThirdSecondInTwoThirdsOneThird]

        if availableNumberOfSegmentsInCollectionView > 1 {

            let leftThirdInTwoThirdsOneThirdExtra = CGRect(x: rightThirdFirstInTwoThirdsOneThird.maxX + Constants.spacing, y: y, width: calculatedItemWidth, height: Constants.itemHeight - Constants.spacing)
            let rightThirdFirstInTwoThirdsOneThirdExtra = CGRect(x: leftThirdInTwoThirdsOneThirdExtra.maxX + Constants.spacing, y: y, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
            let rightThirdSecondInTwoThirdsOneThirdExtra = CGRect(x: leftThirdInTwoThirdsOneThirdExtra.maxX + Constants.spacing, y: rightThirdFirstInTwoThirdsOneThirdExtra.maxY + Constants.spacing, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
            
            segmentRects += [leftThirdInTwoThirdsOneThirdExtra, rightThirdFirstInTwoThirdsOneThirdExtra, rightThirdSecondInTwoThirdsOneThirdExtra]
        }
    }
    
    private func calculateOneThirdTwoThirdsSegment(x: CGFloat, y: CGFloat) {
        
        let leftThirdFirstInOneThirdTwoThirds = CGRect(x: x, y: y, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
        let leftThirdSecondInOneThirdTwoThirds = CGRect(x: x, y: leftThirdFirstInOneThirdTwoThirds.maxY + Constants.spacing, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
        let rightThirdInOneThirdTwoThirds = CGRect(x: leftThirdFirstInOneThirdTwoThirds.maxX + Constants.spacing, y: y, width: calculatedItemWidth, height: Constants.itemHeight - Constants.spacing)
        
        segmentRects = [leftThirdFirstInOneThirdTwoThirds, leftThirdSecondInOneThirdTwoThirds, rightThirdInOneThirdTwoThirds]
        
        if availableNumberOfSegmentsInCollectionView > 1 {

            let leftThirdFirstInOneThirdTwoThirdsExtra = CGRect(x: rightThirdInOneThirdTwoThirds.maxX + Constants.spacing, y: y, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
            let leftThirdSecondInOneThirdTwoThirdsExtra = CGRect(x: rightThirdInOneThirdTwoThirds.maxX + Constants.spacing, y: leftThirdFirstInOneThirdTwoThirdsExtra.maxY + Constants.spacing, width: calculatedItemWidth, height: calculatedHeightForSmallItem)
            let rightThirdInOneThirdTwoThirdsExtra = CGRect(x: leftThirdFirstInOneThirdTwoThirdsExtra.maxX + Constants.spacing, y: y, width: calculatedItemWidth, height: Constants.itemHeight - Constants.spacing)
            
            segmentRects += [leftThirdFirstInOneThirdTwoThirdsExtra, leftThirdSecondInOneThirdTwoThirdsExtra, rightThirdInOneThirdTwoThirdsExtra]
        }
    }
    
    // Determine the next segment style.
    private func changeSegmentStyle(numberOfItemsInCollectionView: Int, index: Int, segment: inout MosaicSegmentStyle) {
        switch numberOfItemsInCollectionView - index {
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
