//
//  TimetableDataSOurce.swift
//  KUtalog
//
//  Created by HASAN CAN on 10.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import CoreData

protocol TimetableDataSourceDelegate {
    func scheduleLoaded (schedule: Schedule?)
}

class TimetableDataSource {
    // MARK: - Core Data
    lazy var persistentContainer = DataController.shared.persistentContainer
    // MARK: - NSFetchedResultsController
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    lazy var fetchedResultsController: NSFetchedResultsController<Schedule> = {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "uid", ascending: false)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: "schedule")
        controller.delegate = fetchedResultsControllerDelegate
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return controller
    }()
    
    var delegate: TimetableDataSourceDelegate?
    
    func loadSchedule(uid: String) {
        let fetchedObjects = fetchedResultsController.fetchedObjects?.filter({ schedule in
            schedule.uid == uid
        })
        if let currentSchedule = fetchedObjects?.first {
            DispatchQueue.main.async {
                self.delegate?.scheduleLoaded(schedule: currentSchedule)
            }
        } else {
            let newSchedule = Schedule(context: persistentContainer.viewContext)
            newSchedule.uid = uid
            try? persistentContainer.viewContext.save()
            DispatchQueue.main.async {
                self.delegate?.scheduleLoaded(schedule: newSchedule)
            }
        }
    }
    
    func deleteCourse(course: Course?) {
        course?.schedules? = NSSet()
        try? self.persistentContainer.viewContext.save()
    }
}
