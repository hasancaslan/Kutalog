//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Ceren on 9.12.2019.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var date: Date?
    @NSManaged public var moduleCode: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?

}
