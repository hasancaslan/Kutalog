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
}

class TasksDataSource {
    // MARK: - Core Data
    /**
     A persistent container to set up the Core Data stack.
     */
    lazy var persistentContainer = DataController.shared.persistentContainer
    
    func createTask(uid: String, title: String?, moduleCode: String?, description: String?, date: Date?, course: Course) {
        let task = Task(context: persistentContainer.viewContext)
        task.uid = uid
        task.title = title
        task.moduleCode = moduleCode
        task.taskDescription = description
        task.date = date
        task.course = course
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        // Create a fetched results controller and set its fetch request, context, and delegate.
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: persistentContainer.viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        
        // Perform the fetch.
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
}
