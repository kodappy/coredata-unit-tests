//
//  CoreData_ContactListTests.swift
//  CoreData-ContactListTests
//
//  Created by Vincent Grossier on 19/01/2020.
//  Copyright © 2020 Vincent Grossier. All rights reserved.
//

import XCTest
import CoreData
@testable import CoreData_ContactList

class CoreDataContactTests: XCTestCaseInMemory {
    
    var sut: ContactStorageManager!

    override func setUp() {
        super.setUp()
        initStubs()
        sut = ContactStorageManager(persistentContainer: mockPersistentContainer)
    }

    override func tearDown() {
        sut = nil
        flush()
        super.tearDown()
    }
}

// MARK: CRUD Tests

extension CoreDataContactTests {
    
    func testInsert() {
        let contact = sut.insert(firstName: "Johnny", lastName: "Uta", email: "johnny.uta@fbi.us", phone: "911911911")
        XCTAssertNotNil(contact)
    }
    
    func testFetch_countEquals2() {
        let results = sut.fetch()
        XCTAssertEqual(results.count, 2)
    }
    
    func testRemove_fetchEquals1() {
        let items = sut.fetch()
        let item = items.first!
        
        let numberOfItems = items.count
        
        sut.remove(objectId: item.objectID)
        sut.save()
        
        XCTAssertEqual(sut.fetch().count, numberOfItems - 1)
    }
}

// MARK: Stubs initialization

extension CoreDataContactTests {
    
    private func initStubs() {
        func insertContactItem(firstName: String, lastName: String, email: String, phone: String) {
            let contact = NSEntityDescription.insertNewObject(forEntityName: "ContactItem", into: mockPersistentContainer.viewContext)
            contact.setValue(firstName, forKey: "firstName")
            contact.setValue(lastName, forKey: "lastName")
            contact.setValue(email, forKey: "email")
            contact.setValue(phone, forKey: "phone")
        }
        
        insertContactItem(firstName: "John", lastName: "Doe", email: "john.doe@testme.com", phone: "0606060606")
        insertContactItem(firstName: "Janne", lastName: "Darc", email: "janne.dark@testme.com", phone: "0707070707")
        
        do {
            try mockPersistentContainer.viewContext.save()
        } catch {
            print("Unable to save stubs")
        }
    }
}
