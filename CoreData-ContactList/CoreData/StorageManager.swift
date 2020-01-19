//
//  StorageManager.swift
//  CoreData-ContactList
//
//  Created by Vincent Grossier on 19/01/2020.
//  Copyright © 2020 Vincent Grossier. All rights reserved.
//

import UIKit
import CoreData

class StorageManager {
    
    internal let persistentContainer: NSPersistentContainer
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    convenience init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unable to get shared app delegate")
        }
        
        let persistentContainer = appDelegate.persistentContainer
        self.init(persistentContainer: persistentContainer)
    }
}
