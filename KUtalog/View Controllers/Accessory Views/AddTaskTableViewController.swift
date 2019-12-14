//
//  AddTaskTableViewController.swift
//  KUtalog
//
//  Created by Ceren on 12.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import ExpandableCell

extension AddTaskTableViewController: DatePickerTableViewCellDelegate {
    func getSelectedDate(date: Date) {
        task?.date = date
        print(date)
    }
}


class AddTaskTableViewController: UITableViewController {
    var task: Task?
    var datePickerTableViewCell = DatePickerTableViewCell()
    
    @IBOutlet var addTaskTableView: UITableView!
    var dataSource: TasksDataSource!
    var selectedRowIndex: Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTableViewCell.delegate = self
        addTaskTableView.delegate = self
        addTaskTableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePickerTableViewCell")
        //addTaskTableView.expandableDelegate = self
        //addTaskTableView.animation = .automatic
        //addTaskTableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "ExpandableTableViewCell")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return datePickerTableViewCell
        }
        print("we have a problem")
        return datePickerTableViewCell
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
