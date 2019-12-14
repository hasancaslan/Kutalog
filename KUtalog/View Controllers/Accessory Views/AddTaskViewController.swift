//
//  AddTaskViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

extension AddTaskViewController: DatePickerTableViewCellDelegate {
    func getSelectedDate(date: Date) {
        task?.date = date
        
        print(date)
    }
}

extension AddTaskViewController: PickerTableViewCellDelegate {
    func pickedCourse(course: String) {
        //task?.course = course
        print(course)
    }
    
    
}

extension AddTaskViewController: TextFieldTableViewCellDelegate {
    func getTitle(title: String) {
        task?.title = title
        print(title)
    }
    
    func getDescription(description: String) {
        // Hata veriyor, description immutablemış çünkü.
        //task?.description = description
        print(description)
    }
    
    
}

extension AddTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField?.placeholder = "Title"
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
             let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
            cell.delegate = self
              return cell
         } else if indexPath.row == 3 {
              let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
              cell.textField?.placeholder = "Description"
            cell.delegate = self
              return cell
         }
        return UITableViewCell()
    }
}

class AddTaskViewController: UIViewController {
    var task: Task?
    var dataSource: TasksDataSource!
    @IBOutlet weak var addTaskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
