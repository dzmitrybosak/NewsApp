//
//  Quicksort.swift
//  News
//
//  Created by Dzmitry Bosak on 10/15/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import Foundation

final class SortService {
    
    static let shared = SortService()
    private init() {}
    
    func quicksort(_ array: [Article]) -> [Article] {
        guard array.count > 1 else { return array }
        
        guard let pivot = array[array.count/2].publishedAt else { fatalError() } // стержень – выбирается индекс посередине массива
        
        let less = array.filter { $0.publishedAt ?? Date() < pivot } // меньший - массив, где значения меньше, чем стержень
        let equal = array.filter { $0.publishedAt == pivot } // равный - массив из значений, равных стержню
        let greater = array.filter { $0.publishedAt ?? Date() > pivot } // больший - массив, где значения больше, чем стержень
        
        return quicksort(less) + equal + quicksort(greater) // рекурсивно сортируются меньший и больший, а затем склеивается с равным
    }
}
