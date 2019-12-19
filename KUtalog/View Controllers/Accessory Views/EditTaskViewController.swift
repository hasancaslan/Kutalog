//
//  EditTaskViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol EditTaskViewControllerDelegate{
    func preselectedCourse(row: Int)
}

extension EditTaskViewController: TasksDataSourceDelegate {
    func scheduledCoursesLoaded(courseList: [Course]?) {
        scheduledCourses = courseList
        editTaskTableView.reloadData()
    }
}

extension EditTaskViewController: DatePickerTableViewCellDelegate {
    func getSelectedDate(date: Date) {
        task?.date = date
        if NSDate().earlierDate(date) == date {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
}

extension EditTaskViewController: PickerTableViewCellDelegate {
    func pickedCourse(course: String, row: Int) {
        if let courses = scheduledCourses {
            task?.course = Array(courses)[row]
        }
    }
}

extension EditTaskViewController: TextFieldTableViewCellDelegate {
    func getTitle(title: String?) {
        task?.title = title
    }
    
    func getDescription(description: String?) {
        task?.taskDescription = description
    }
    
    
}

extension EditTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
            cell.delegate = self
            cell.datePicker.date = task?.date ?? Date.init()
            return cell
        } else if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField?.placeholder = "Title"
            cell.delegate = self
            cell.textField.text = task?.title
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PickerTableViewCell", for: indexPath) as! PickerTableViewCell
            cell.delegate = self
            if let courses = scheduledCourses {
                cell.pickerData = courses.map { ($0.title ?? "") }
                let row = scheduledCourses?.firstIndex(of: task?.course ?? Course()) ?? 0
                cell.coursePickerView.selectRow(row, inComponent: 0, animated: false)
            } else {
                cell.pickerData = ["No Course"]
            }
            cell.coursePickerView.reloadAllComponents()
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldTableViewCell", for: indexPath) as! TextFieldTableViewCell
            cell.textField?.placeholder = "Description"
            cell.delegate = self
            cell.textField.text = task?.taskDescription
            return cell
        }
        return UITableViewCell()
    }
}

class EditTaskViewController: UIViewController {
    var task: Task?
    var dataSource = TasksDataSource()
    var scheduledCourses: [Course]?
    var delegate: EditTaskViewControllerDelegate?
    
    @IBOutlet weak var editTaskTableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        editTaskTableView.dataSource = self
        dataSource.delegate = self
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            task?.uid = uid
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
        if task?.title != "" {
            //dataSource.createTask(task?)
            self.navigationController?.popViewController(animated: true)
        } else {
            let alert = UIAlertController(title: "Please Enter a Title", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}



