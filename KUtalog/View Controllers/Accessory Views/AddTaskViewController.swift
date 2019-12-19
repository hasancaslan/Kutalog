//
//  AddTaskViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth

extension AddTaskViewController: TasksDataSourceDelegate {
    func scheduledCoursesLoaded(courseList: [Course]?) {
        scheduledCourses = courseList
        addTaskTableView.reloadData()
    }
}

extension AddTaskViewController: DatePickerTableViewCellDelegate {
    func getSelectedDate(date: Date) {
        newTask.date = date
    }
}

extension AddTaskViewController: PickerTableViewCellDelegate {
    func pickedCourse(course: String, row: Int) {
        if let courses = scheduledCourses {
            newTask.course = Array(courses)[row]
        }
    }
}

extension AddTaskViewController: TextFieldTableViewCellDelegate {
    func getTitle(title: String?) {
        newTask.title = title
    }
    
    func getDescription(description: String?) {
        newTask.taskDescription = description
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
            newTask.date = cell.datePicker.date
            return cell
        } else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField?.placeholder = "Title"
            cell.delegate = self
            newTask.title = cell.textField.text
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
            cell.delegate = self
            if let courses = scheduledCourses {
                cell.pickerData = courses.map { ($0.title ?? "") }
                if let courses = scheduledCourses {
                    newTask.course = courses.first
                }
            } else {
                cell.pickerData = ["No Course"]
            }
            cell.coursePickerView.reloadAllComponents()
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField?.placeholder = "Description"
            cell.delegate = self
            newTask.taskDescription = cell.textField.text
            return cell
        }
        return UITableViewCell()
    }
}

class AddTaskViewController: UIViewController {
    var newTask = NewTask()
    var dataSource = TasksDataSource()
    var scheduledCourses: [Course]?
    
    @IBOutlet weak var addTaskTableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTaskTableView.dataSource = self
        dataSource.delegate = self
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            newTask.uid = uid
            dataSource.loadScheduledCourses(uid: uid)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func doneTapped(_ sender: Any) {
        var alertTitle = ""
        var success = false
        if newTask.title != "" {
            dataSource.createTask(newTask)
            alertTitle = "Your task is succesfully created!"
            success = true
        } else {
            alertTitle = "Please Enter a Title"
            success = false
        }
        let alert = UIAlertController(title: alertTitle, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true)
    }
}
