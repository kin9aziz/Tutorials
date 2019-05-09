//
//  ViewController.swift
//  CoreDataSample
//
//  Created by Quang Tran on 2/21/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var moc: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = appDelegate.persistentContainer.viewContext
    }

    override func viewDidAppear(_ animated: Bool) {
        // Test inserting a person
        insertPerson()
        showPersonsInfo(persons: personsList())
        
        // Show the info of the first person
        guard let personID = firstPersonID() else {
            print("First person id is nil.")
            return
        }

        showPersonInfoWithID(id: personID)

        // Test updating info of the first person
        updatePersonInfoWithID(id: personID)
        showPersonInfoWithID(id: personID)

        // Test deleting the first person
        deletePersonWithID(id: personID)
        showPersonInfoWithID(id: personID)
    }
    
    func clearAllPersons() {
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Person.fetchRequest())
        do {
            try moc.execute(batchDeleteRequest)
        } catch let error as NSError {
            print("Error when clearing all persons: \(error)")
            return
        }
        
        appDelegate.saveContext()
        print("Deleted all persons.")
    }
    
    func insertPerson() {
        let person = Person(context: moc)
        person.name = "Quang"
        person.age = 30
        appDelegate.saveContext()
        print("Inserted the person.")
    }
    
    func firstPersonID() -> String? {
        let firstPerson = personsList().first
        guard firstPerson != nil else {
            print("Could not found first person.")
            return nil
        }
        return firstPerson!.objectID.uriRepresentation().absoluteString
    }
    
    func showPersonsInfo(persons: [Person]) {
        guard persons.count > 0 else {
            print("No any persons to show.")
            return
        }
        
        print("Person list:")
        for person in persons {
            let uri = person.objectID.uriRepresentation().absoluteString
            print("\tName: \(String(describing: person.name!)) - Age: \(person.age) - URI: \(uri)")
        }
    }
    
    func personsList() -> [Person] {
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        do {
            let persons = try moc.fetch(fetchRequest)
            return persons
        } catch let error as NSError {
            print("Error when fetching persons: \(String(describing: error))")
        }
        return []
    }
    
    func showPersonInfoWithID(id: String) {
        let uri = URL(string: id)!
        let moi = moc.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri)
        let person = moc.object(with: moi!) as! Person
        
        guard person.isFault == false else {
            print("Could not show the info of the person with ID: \(id). This person is not registered in the context. ")
            return
        }
        
        print("Person info with id: \(id)")
        print("\tName: \(String(describing: person.name!)) - Age: \(person.age)")
    }
    
    func updatePersonInfoWithID(id: String) {
        let uri = URL(string: id)!
        let moi = moc.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri)
        let person = moc.object(with: moi!) as! Person
        person.name = "Quang 2"
        person.age = 18
        appDelegate.saveContext()
        print("Updated the person with id: \(id)")
    }
    
    func deletePersonWithID(id: String) {
        let uri = URL(string: id)!
        let moi = moc.persistentStoreCoordinator?.managedObjectID(forURIRepresentation: uri)
        let person = moc.object(with: moi!) as! Person
        moc.delete(person)
        appDelegate.saveContext()
        print("Deleted the person with id: \(id)")
    }
}

