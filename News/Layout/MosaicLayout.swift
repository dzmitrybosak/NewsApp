//
//  PinterestLayout.swift
//  News
//
//  Created by Dzmitry Bosak on 9/7/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

class MosaicLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cachedAttributes = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        
        guard let cv = collectionView else { return }
        
        // Reset cached info
        cachedAttributes.removeAll()
        contentBounds = CGRect(origin: .zero, size: cv.bounds.size)
        
        // for every item
        // - Prepare attributes
        // - Store attributes in cachedAttributes array
        // - union contentBounds with attributes.frame
        createAttributes()
    }
    
    private func createAttributes() {
        // calculate the sizes, positions, transform, etc. for cells
        
        // 1. Only calculate once
        guard cachedAttributes.isEmpty == true, let collectionView = collectionView else {
            return
        }
        
        // 2. Pre-Calculates the X Offset for every column and adds an array to increment the currently max Y Offset for each column
        // 3. Iterates through the list of items in the first section
        // 4. Asks the delegate for the height of the picture and the annotation and calculates the cell frame.
        // 5. Creates an UICollectionViewLayoutItem with the frame and add it to the cache
        // 6. Updates the collection view content height
    }
    
    override var collectionViewContentSize: CGSize {
        return contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let cv = collectionView else { return false }
        
        return !newBounds.size.equalTo(cv.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cachedAttributes[indexPath.item]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedAttributes.filter { (attributes: UICollectionViewLayoutAttributes) -> Bool in
            return rect.intersects(attributes.frame)
        }
    }
    
}
