//
//  ContactStorageManager.swift
//  CoreData-ContactList
//
//  Created by Vincent Grossier on 19/01/2020.
//  Copyright © 2020 Vincent Grossier. All rights reserved.
//

import Foundation
import CoreData

final class ContactStorageManager: StorageManager {
    
    // MARK: CRUD Model
    
    func insert(firstName: String, lastName: String, email: String, phone: String) -> ContactItem? {
        guard let contact = NSEntityDescription.insertNewObject(forEntityName: "ContactItem", into: backgroundContext) as? ContactItem else {
            return nil
        }
        
        contact.firstName = firstName
        contact.lastName = lastName
        contact.email = email
        contact.phone = phone
        return contact
    }
    
    func fetch() -> [ContactItem] {
        let request: NSFetchRequest<ContactItem> = ContactItem.fetchRequest()
        let results = try? persistentContainer.viewContext.fetch(request)
        return results ?? [ContactItem]()
    }
    
    func remove(objectId: NSManagedObjectID) {
        let object = backgroundContext.object(with: objectId)
        backgroundContext.delete(object)
    }
    
    func save() {
        if backgroundContext.hasChanges {
            try? backgroundContext.save()
        }
    }
}
