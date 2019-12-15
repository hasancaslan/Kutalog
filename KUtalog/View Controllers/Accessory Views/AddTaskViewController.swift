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
        print(date)
    }
}

extension AddTaskViewController: PickerTableViewCellDelegate {
    func pickedCourse(course: String, row: Int) {
        if let courses = scheduledCourses {
            newTask.course = Array(courses)[row]
        }
        print(course)
    }
}

extension AddTaskViewController: TextFieldTableViewCellDelegate {
    func getTitle(title: String?) {
        newTask.title = title
        print(title)
    }
    
    func getDescription(description: String?) {
        newTask.taskDescription = description
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
            print("hasan")
            if let courses = scheduledCourses {
                cell.pickerData = courses.map { ($0.title ?? "") }
                print(cell.pickerData)
            } else {
                cell.pickerData = ["No Course"]
            }
            cell.coursePickerView.reloadAllComponents()
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
        dataSource.createTask(newTask)
        print(newTask)
        self.dismiss(animated: true, completion: nil)
    }
    
}
