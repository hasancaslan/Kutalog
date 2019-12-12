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
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KUtalog")
        
        container.loadPersistentStores { storeDesription, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        
        // Merge the changes from other contexts automatically.
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()
    
    // MARK: - NSFetchedResultsController
    
    /**
     A fetched results controller delegate to give consumers a chance to update
     the user interface when content changes.
     */
    weak var fetchedResultsControllerDelegate: NSFetchedResultsControllerDelegate?
    
    /**
     A fetched results controller to fetch Quake records sorted by time.
     */
    lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        
        // Create a fetch request for the Quake entity sorted by time.
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
