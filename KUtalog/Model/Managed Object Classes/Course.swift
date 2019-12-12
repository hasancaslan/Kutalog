//
//  Course+ Extensions.swift
//  KUtalog
//
//  Created by HASAN CAN on 10.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import CoreData

class Course: NSManagedObject {
       @NSManaged public var department: String?
       @NSManaged public var faculty: String?
       @NSManaged public var moduleCode: String?
       @NSManaged public var moduleCredit: String?
       @NSManaged public var moduleDescription: String?
       @NSManaged public var preclusion: String?
       @NSManaged public var semesterData: Semesters?
       @NSManaged public var title: String?
       @NSManaged public var workload: String?
     @NSManaged public var tasks: NSSet?
    @NSManaged public var schedules: NSSet?
    
    func update(with module: Module) {
        let data = Semesters(semesterData: module.semesterData)
        title = module.title
        moduleCode = module.moduleCode
        department = module.department
        faculty = module.faculty
        moduleCredit = module.moduleCredit
        moduleDescription = module.description
        preclusion = module.preclusion
        semesterData = data
    }
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Course> {
           return NSFetchRequest<Course>(entityName: "Course")
       }
}
