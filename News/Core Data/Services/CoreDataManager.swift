//
//  CoreDataManager.swift
//  News
//
//  Created by Dzmitry Bosak on 9/4/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import CoreData

// MARK: - Constants

private enum Constants {
    static let modelName = "NewsDataModel"
}

final class CoreDataManager {
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    private init() {}
    
    private let coreDataStack = CoreDataStack(modelName: Constants.modelName)
    
    var context: NSManagedObjectContext {
        return coreDataStack.managedObjectContext
    }
}
