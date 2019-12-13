//
//  TasksViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import CoreData

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
    
    // MARK:- Helpers

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// MARK:- Table View Delegate
extension TasksViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            return 250
        }
        return 100
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

// MARK:- Table View Data Source
extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? TaskTableViewCell {
            cell.configure(task: allTasks?[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - NS Fetched Results Controller Delegate
extension TasksViewController: NSFetchedResultsControllerDelegate {
    /**
     Reloads the table view when the fetched result controller's content changes.
     */
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
}

extension TasksViewController: TasksDataSourceDelegate {
    func taskListLoaded(taskList: [Task]?) {
        self.allTasks = taskList
        self.tasksTableView.reloadData()
    }
}

