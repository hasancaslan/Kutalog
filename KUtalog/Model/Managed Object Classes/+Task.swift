//
//  +Task.swift
//  KUtalog
//
//  Created by HASAN CAN on 19.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation

extension Task {
    func update(with taskToUpdate: Task) {
        self.course = taskToUpdate.course
        self.date = taskToUpdate.date
        self.moduleCode = taskToUpdate.moduleCode
        self.taskDescription = taskToUpdate.taskDescription
        self.title = taskToUpdate.title
        self.uid = taskToUpdate.uid
    }
}
