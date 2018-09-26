//
//  LikeService.swift
//  News
//
//  Created by Dzmitry Bosak on 9/17/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import CoreData

/*final class LikeService {
    private let coreDataManager = CoreDataManager.shared
    
    static let shared = LikeService()
    private init() { }
    
    func saveLike() {
        let context = coreDataManager.context
        
        context.perform {
            //_ = LikeEntity.create(from: article, in: context)
            try? context.save()
        }
    }
    
    func fetchStoredLikes() {
        
    }
    
    private func fetchLikeEntities(from context: NSManagedObjectContext) -> [LikeEntity] {
        let fetchRequest = NSFetchRequest<LikeEntity>(entityName: String(describing: LikeEntity.self))
        return (try? context.fetch(fetchRequest)) ?? []
    }
}*/
