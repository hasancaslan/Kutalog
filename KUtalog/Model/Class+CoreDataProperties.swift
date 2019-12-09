//
//  Class+CoreDataProperties.swift
//  
//
//  Created by HASAN CAN on 9.12.2019.
//
//

import Foundation
import CoreData


extension Class {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Class> {
        return NSFetchRequest<Class>(entityName: "Class")
    }

    @NSManaged public var moduleCode: String?
    @NSManaged public var title: String?
    @NSManaged public var moduleDescription: String?
    @NSManaged public var moduleCredit: String?
    @NSManaged public var department: String?
    @NSManaged public var faculty: String?
    @NSManaged public var preclusion: String?
    @NSManaged public var workload: String?
    @NSManaged public var semester: Double?
    @NSManaged public var examDate: String?
    @NSManaged public var examDuration: Double?

}
