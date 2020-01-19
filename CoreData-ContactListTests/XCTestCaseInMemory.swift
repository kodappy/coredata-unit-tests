//
//  XCTestCaseInMemory.swift
//  CoreData-ContactListTests
//
//  Created by Vincent Grossier on 19/01/2020.
//  Copyright © 2020 Vincent Grossier. All rights reserved.
//

import XCTest
import CoreData

class XCTestCaseInMemory: XCTestCase {
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoreData_ContactList", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            
            if let error = error {
                fatalError("Unable to create in memory persistent store")
            }
        }
        
        return persistentContainer
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
    }()
    
    func flush() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactItem")
        let objects = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        
        objects.forEach { object in
            guard let object = object as? NSManagedObject else {
                return
            }
            mockPersistentContainer.viewContext.delete(object)
        }
        
        try? mockPersistentContainer.viewContext.save()
    }
}
