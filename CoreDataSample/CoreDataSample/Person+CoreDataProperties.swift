//
//  Person+CoreDataProperties.swift
//  CoreDataSample
//
//  Created by Quang Tran on 2/21/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var name: String?
    @NSManaged public var age: Int16

}
