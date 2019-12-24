//
//  ClassSearchDataSource.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation
import CoreData

protocol ClassSearchDataSourceDelegate {
    func courseListLoaded(courseList: [Course]?)
    func courseDetailLoaded()
}

extension ClassSearchDataSourceDelegate {
    func courseListLoaded(courseList: [Course]?) { }
    func courseDetailLoaded() { }
}

class ClassSearchDataSource {
    // MARK: - Core Data
    /**
     A persistent container to set up the Core Data stack.
     */
    lazy var persistentContainer = DataController.shared.persistentContainer
    lazy var viewContext = DataController.shared.viewContext
    /**
     Fetches the module feed from the remote server, and imports it into Core Data.
     */
    var delegate: ClassSearchDataSourceDelegate?
    let baseUrl = "https://api.nusmods.com/v2/"
    
    func fetchCourseList(completionHandler: @escaping (Error?) -> Void) {
        // Create a URL to load, and a URLSession to load it.
        guard let url = URL(string: "\(baseUrl)2018-2019/moduleInfo.json") else {
            completionHandler(ClassError.urlError)
            return
        }
        let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Create a URLSession dataTask to fetch the feed.
        let dataTask = session.dataTask(with: request) {data, _, error in
            
            // Alert the user if no data comes back.
            guard let data = data else {
                completionHandler(ClassError.networkUnavailable)
                return
            }
            
            // Decode the JSON and import it into Core Data.
            do {
                // Decode the JSON into codable type [Module].
                let decoder = JSONDecoder()
                let moduleList = try decoder.decode([Module].self, from: data)
                
                // Import the [Module] into Core Data.
                self.importClasses(from: moduleList)
                
            } catch {
                // Alert the user if data cannot be digested.
                completionHandler(ClassError.wrongDataFormat)
                return
            }
            completionHandler(nil)
        }
        // Start the task.
        dataTask.resume()
    }
    
    func addCourseToSchedule(uid: String, course: Course?, completionHandler: @escaping (Error?) -> Void) {
        let fetchedObjects = scheduleFetchedResultsController.fetchedObjects?.filter({ schedule in
            schedule.uid == uid
        })
        if let currentSchedule = fetchedObjects?.first {
            let scheduledCoursesArray = currentSchedule.courses?.allObjects as! [Course]
            var conflictingCourses:[Course] = []
            for scheduledCourse in scheduledCoursesArray {
                if !courseTimeExistanceCheck(existingCourse: scheduledCourse, newCourse: course) {
                    completionHandler(ClassError.courseTimeDoesNotExistError)
                    return
                }
                if courseConflictCheck(existingCourse: scheduledCourse, newCourse: course) {
                    conflictingCourses.append(scheduledCourse)
                }
            }
            if conflictingCourses.isEmpty{
                if let schedules = course?.schedules?.adding(currentSchedule) {
                    course?.schedules = NSSet(set: schedules)
                }
                try? viewContext.save()
                completionHandler(nil)
            } else {
                completionHandler(ClassError.conflictCourseError)
            }
        } else {
            let newSchedule = Schedule(context: viewContext)
            newSchedule.uid = uid
            if let schedules = course?.schedules?.adding(newSchedule) {
                course?.schedules = NSSet(set: schedules)
            }
            try? viewContext.save()
            completionHandler(nil)
        }
    }
    
    func courseTimeExistanceCheck(existingCourse: Course, newCourse: Course?) -> Bool {
        guard let start1 = existingCourse.semesterData?.semesterData.first??.timetable?.first??.startTime else {
            print("no start1")
            return false
        }
        guard let end1 = existingCourse.semesterData?.semesterData.first??.timetable?.first??.endTime else {
            print("no end1")
            return false
        }
        guard let start2 = newCourse?.semesterData?.semesterData.first??.timetable?.first??.startTime else {
            print("no start2")
            return false
        }
        guard let end2 = newCourse?.semesterData?.semesterData.first??.timetable?.first??.endTime else {
            print("no end2")
            return false
        }
        return true
    }
    
    func courseConflictCheck(existingCourse: Course, newCourse: Course?) -> Bool {
        if let newCourse = newCourse {
            let day1 = existingCourse.semesterData?.semesterData.first??.timetable?.first??.day ?? "Friday"
            guard let start1 = existingCourse.semesterData?.semesterData.first??.timetable?.first??.startTime else {
                print("no start1")
                return false
            }
            guard let end1 = existingCourse.semesterData?.semesterData.first??.timetable?.first??.endTime else {
                print("no end1")
                return false
            }
            let day2 = newCourse.semesterData?.semesterData.first??.timetable?.first??.day ?? "Friday"
            guard let start2 = newCourse.semesterData?.semesterData.first??.timetable?.first??.startTime else {
                print("no start2")
                return false
            }
            guard let end2 = newCourse.semesterData?.semesterData.first??.timetable?.first??.endTime else {
                print("no end2")
                return false
            }
            if day1 == day2 && Int(start1) ?? Int.max <= Int(end2) ?? Int.min && Int(start2) ?? Int.max <= Int(end1) ?? Int.min {
                print("\(day1) \(start1) \(end1) \(day2) \(start2) \(end2)")
                return true
            }
            return false
        }
        return true
    }
    
    func loadCourseList() {
        let courses = self.fetchedResultsController.fetchedObjects
        self.delegate?.courseListLoaded(courseList: courses)
    }
    
    private func importClasses(from moduleList: [Module]) {
        guard !moduleList.isEmpty else { return }
        
        // Create a private queue context.
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        // Process records in batches to avoid a high memory footprint.
        let batchSize = 256
        let count = moduleList.count
        
        // Determine the total number of batches.
        var numBatches = count / batchSize
        numBatches += count % batchSize > 0 ? 1 : 0
        
        for batchNumber in 0 ..< numBatches {
            
            // Determine the range for this batch.
            let batchStart = batchNumber * batchSize
            let batchEnd = batchStart + min(batchSize, count - batchNumber * batchSize)
            let range = batchStart..<batchEnd
            
            // Create a batch for this range from the decoded JSON.
            let modulesBatch = Array(moduleList[range])
            
            // Stop the entire import if any batch is unsuccessful.
            if !importOneBatch(modulesBatch, taskContext: taskContext) {
                return
            }
        }
    }
    
    /**
     Imports one batch of modules, creating managed objects from the new data,
     and saving them to the persistent store, on a private queue. After saving,
     resets the context to clean up the cache and lower the memory footprint.
     
     NSManagedObjectContext.performAndWait doesn't rethrow so this function
     catches throws within the closure and uses a return value to indicate
     whether the import is successful.
     */
    private func importOneBatch(_ modulesBatch: [Module], taskContext: NSManagedObjectContext) -> Bool {
        
        var success = false
        
        // taskContext.performAndWait runs on the URLSession's delegate queue
        // so it won’t block the main thread.
        taskContext.performAndWait {
            // Create a new record for each course in the batch.
            for moduleData in modulesBatch {
                
                // Create a Course managed object on the private queue context.
                guard let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: taskContext) as? Course else {
                    return
                }
                course.update(with: moduleData)
            }
            
            // Save all insertions and deletions from the context to the store.
            if taskContext.hasChanges {
                do {
                    try taskContext.save()
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                    return
                }
                // Reset the taskContext to free the cache and lower the memory footprint.
                taskContext.reset()
            }
            success = true
        }
        return success
    }
    
    private func importOneModule(_ module: Module) {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        guard let course = NSEntityDescription.insertNewObject(forEntityName: "Course", into: context) as? Course else {
            return
        }
        course.update(with: module)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error: \(error)\nCould not save Core Data context.")
                return
            }
            context.reset()
        }
    }
    
    func loadCourseDetail(moduleCode: String, course: Course) {
        guard let url = URL(string: "\(baseUrl)2018-2019/modules/\(moduleCode).json") else {
            return
        }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dataTask = session.dataTask(with: request) {data, _, error in
            guard let data = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let module = try decoder.decode(Module.self, from: data)
                course.update(with: module)
                do {
                    try self.viewContext.save()
                    DispatchQueue.main.async {
                        self.delegate?.courseDetailLoaded()
                    }
                } catch {
                    print("Error: \(error)\nCould not save Core Data context.")
                    return
                }
            } catch {
                return
            }
        }
        dataTask.resume()
    }
    
    func deleteCourseFromSchedule(_ courseToDelete: Course) {
        persistentContainer.viewContext.delete(courseToDelete)
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
    lazy var fetchedResultsController: NSFetchedResultsController<Course> = {
        
        // Create a fetch request for the Course entity sorted by time.
        let fetchRequest = NSFetchRequest<Course>(entityName: "Course")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "moduleCode", ascending: true)]
        
        // Create a fetched results controller and set its fetch request, context, and delegate.
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: viewContext,
                                                    sectionNameKeyPath: nil, cacheName: "courses")
        controller.delegate = fetchedResultsControllerDelegate
        
        // Perform the fetch.
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        return controller
    }()
    
    lazy var scheduleFetchedResultsController: NSFetchedResultsController<Schedule> = {
        let fetchRequest = NSFetchRequest<Schedule>(entityName: "Schedule")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "uid", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: viewContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = fetchedResultsControllerDelegate
        do {
            try controller.performFetch()
        } catch {
            fatalError("Unresolved error \(error)")
        }
        return controller
    }()
}
