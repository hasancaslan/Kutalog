//
//  DataController.swift
//  KUtalog
//
//  Created by HASAN CAN on 9.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation
import CoreData

class DataController {
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    var taskContext: NSManagedObjectContext{
        return persistentContainer.newBackgroundContext()
    }
    static let shared: DataController = {
        return DataController()
    }()

    init() {
        persistentContainer = NSPersistentContainer(name: "KUtalog")
        self.load()
    }

    func configureContexts() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
    }

    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            self.autoSaveViewContext()
            self.configureContexts()
            completion?()
        }
    }
}

// MARK: - Autosaving
extension DataController {
    func autoSaveViewContext(interval: TimeInterval = 8) {
        print("autosaving")
        guard interval > 0 else {
            print("cannot set negative autosave interval")
            return
        }
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            self.autoSaveViewContext(interval: interval)
        }
    }
}
