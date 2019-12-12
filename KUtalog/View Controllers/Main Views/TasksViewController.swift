//
//  TasksViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    @IBOutlet weak var daysSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tasksTableView: UITableView!
    
    var selectedRowIndex = -1
    var thereIsCellTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tasksTableView.delegate = self
        self.tasksTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
// MARK:- Actions
    @IBAction func didDaysSegmentedControlChanged(_ sender: Any) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == selectedRowIndex && thereIsCellTapped {
            return 250
        }
        return 70
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

// MARK:- Table View Delegate
extension TasksViewController: UITableViewDelegate {
    
}

// MARK:- Table View Data Source
extension TasksViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ExpandableTableViewCell"){
            return cell
        }
        return UITableViewCell()
    }
}
