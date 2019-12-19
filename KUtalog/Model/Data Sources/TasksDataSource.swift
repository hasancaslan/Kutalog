//
//  TasksDataSource.swift
//  KUtalog
//
//  Created by HASAN CAN on 10.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import CoreData

protocol TasksDataSourceDelegate {
    func taskListLoaded (taskList: [Task]?)
    func scheduledCoursesLoaded (courseList: [Course]?)
}

extension TasksDataSourceDelegate {
    func taskListLoaded (taskList: [Task]?) { }
    func scheduledCoursesLoaded (courseList: [Course]?) { }
}

class TasksDataSource {
    // MARK: - Core Data
    /**
     A persistent container to set up the Core Data stack.
     */
    lazy var persistentContainer = DataController.shared.persistentContainer
    
    func createTask(_ newTask: NewTask) {
        let task = Task(context: persistentContainer.viewContext)
        task.uid = newTask.uid
        task.title = newTask.title
        task.moduleCode = newTask.course?.moduleCode
        task.taskDescription = newTask.taskDescription
        task.date = newTask.date
        task.course = newTask.course
        try? persistentContainer.viewContext.save()
    }
    
    func deleteTask(_ taskToDelete: Task) {
        persistentContainer.viewContext.delete(taskToDelete)
        try? persistentContainer.viewContext.save()
    }
    
    // MARK: - NSFetchedResultsController
    
    /**
     A fetched results controller delegate to give consumers a chance to update
     the user interface when content changes.
     */
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    /**
     A fetched results controller to fetch Course records sorted by time.
     */
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        
        // Create a fetch request for the Course entity sorted by time.
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        // Create a fetched results controller and set its fetch request, context, and delegate.
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: "tasks")
        controller.delegate = fetchedResultsControllerDelegate
        
        // Perform the fetch.
        do {
            try controller.performFetch()
            
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return controller
    }()
    
    /**
     A fetched results controller to fetch Schedule records sorted by time.
     */
    lazy var scheduleFetchedResultsController: NSFetchedResultsController<Schedule> = {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "uid", ascending: false)]
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.relationshipKeyPathsForPrefetching = ["courses"]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: "scheduledCourses")
        controller.delegate = fetchedResultsControllerDelegate
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        
        return controller
    }()
    
    var delegate: TasksDataSourceDelegate?
    
    func loadListOfTasks() {
        let fetchedObjects = fetchedResultsController.fetchedObjects
        DispatchQueue.main.async {
            self.delegate?.taskListLoaded(taskList: fetchedObjects)
        }
    }
    
    func loadScheduledCourses(uid: String) {
        let fetchedObjects = scheduleFetchedResultsController.fetchedObjects?.filter({ schedule in
            return schedule.uid == uid
        })
        guard let currentSchedule = fetchedObjects?.first else {
            return
        }
        if let courseList = currentSchedule.courses?.allObjects as? [Course]? {
            DispatchQueue.main.async {
                self.delegate?.scheduledCoursesLoaded(courseList: courseList)
            }
        }
    }
}
