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

extension AddTaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerTableViewCell", for: indexPath) as! DatePickerTableViewCell
            cell.delegate = self
            return cell
        }
        print("we have a problem")
        return datePickerTableViewCell
    }
    
    
}

class AddTaskViewController: UIViewController {
    var task: Task?
    var datePickerTableViewCell = DatePickerTableViewCell()

    @IBOutlet weak var addTaskTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerTableViewCell.delegate = self
        addTaskTableView.register(DatePickerTableViewCell.self, forCellReuseIdentifier: "DatePickerTableViewCell")
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
