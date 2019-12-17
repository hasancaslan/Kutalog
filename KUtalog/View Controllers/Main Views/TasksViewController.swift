//
//  TasksViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import CoreData

extension TasksViewController: TaskTableViewCellDelegate {
    func editTapped(task: Task?) {
        
    }
    
    func deleteTapped(task: Task?) {
        if let taskToDelete = task {
            dataSource.deleteTask(taskToDelete)
            print(taskToDelete)
        }
    }
    
}

class TasksViewController: UIViewController {
    @IBOutlet weak var tasksTableView: UITableView!
    let reuseIdentifier = "TaskTableViewCell"
    var selectedRowIndex = -1
    var thereIsCellTapped = false
    var allTasks: [Task]? = [Task]()
    
    private lazy var dataSource: TasksDataSource = {
        let source = TasksDataSource()
        source.fetchedResultsControllerDelegate = self
        source.delegate = self
        return source
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasksTableView.delegate = self
        self.tasksTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataSource.loadListOfTasks()
    }
    
    // MARK:- Helpers
    
     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddTaskViewController {
//            vc.dataSource = self.dataSource
        }
     }
}

// MARK:- Table View Delegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            if let cell = tableView.cellForRow(at: indexPath) as? TaskTableViewCell {
                return 100 + cell.descriptionLabel.frame.height
            }
             return 100
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tasksTableView.cellForRow(at: indexPath)?.backgroundColor = .gray
        
        if self.selectedRowIndex != -1 {
            tasksTableView.cellForRow(at: IndexPath(row: selectedRowIndex, section: 0))?.backgroundColor = .white
        }
        if selectedRowIndex != indexPath.row {
            self.thereIsCellTapped = true
            self.selectedRowIndex = indexPath.row
        }
        else {
            // there is no cell selected anymore
            self.thereIsCellTapped = false
            self.selectedRowIndex = -1
        }
        tasksTableView.beginUpdates()
        tasksTableView.endUpdates()
    }
}

// MARK:- TableView DataSource
extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TaskTableViewCell {
            cell.configure(task: dataSource.fetchedResultsController.fetchedObjects?[indexPath.row])
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - NSFetchedResultsController Delegate
extension TasksViewController: NSFetchedResultsControllerDelegate {
    /**
     Reloads the table view when the fetched result controller's content changes.
     */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tasksTableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tasksTableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tasksTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tasksTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tasksTableView.insertSections(indexSet, with: .fade)
        case .delete: tasksTableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tasksTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
     tasksTableView.endUpdates()
    }
    
}

// MARK: - TasksDataSource Delegate
extension TasksViewController: TasksDataSourceDelegate {
    func taskListLoaded(taskList: [Task]?) {
        self.allTasks = taskList
        tasksTableView.reloadData()
    }
}

