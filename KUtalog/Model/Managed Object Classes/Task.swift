//
//  Task.swift
//  KUtalog
//
//  Created by HASAN CAN on 10.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import CoreData

class Task: NSManagedObject {
       @NSManaged public var moduleCode: String?
       @NSManaged public var taskDescription: String?
       @NSManaged public var title: String?
       @NSManaged public var date: Date?
}
