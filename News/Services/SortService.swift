//
//  Quicksort.swift
//  News
//
//  Created by Dzmitry Bosak on 10/15/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

public final class SortService {
    
    static let shared = SortService()
    private init() {}
    
    func quicksort(_ array: [Article]) -> [Article] {
        guard array.count > 1 else {
            return array
        }
        
        guard let pivot = array[array.count / 2].publishedAt else {
            assertionFailure("Expected not nil published date")
            return []
        }
        
        let less = array.filter { $0.publishedAt ?? Date() < pivot }
        let equal = array.filter { $0.publishedAt == pivot }
        let greater = array.filter { $0.publishedAt ?? Date() > pivot }
        
        return quicksort(less) + equal + quicksort(greater)
    }
}
