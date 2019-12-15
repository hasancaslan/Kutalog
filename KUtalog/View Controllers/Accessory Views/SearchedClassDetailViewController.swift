//
//  SearchedClassDetailViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth

class SearchedClassDetailViewController: UIViewController {
    var course: Course?
    var dataSource: ClassSearchDataSource!
    @IBOutlet weak var classCodeLabel: UILabel!
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var firstInfoLineLabel: UILabel!
    @IBOutlet weak var semesterLabel: UILabel!
    @IBOutlet weak var classDetailsText: UITextView!
    @IBOutlet weak var preclusionLabel: UILabel!
    @IBOutlet weak var preclusionText: UITextView!
    @IBOutlet weak var semester1ExamLabel: UILabel!
    @IBOutlet weak var semester1ExamText: UITextView!
    @IBOutlet weak var semester2ExamLabel: UILabel!
    @IBOutlet weak var semester2ExamText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        classCodeLabel.text = course?.moduleCode
        classNameLabel.text = course?.title
        firstInfoLineLabel.text = "\(course?.department ?? "") - \(course?.faculty ?? "")"
        let semesterArray = course?.semesterData?.semesterData.map { sem -> String in
            if let s = sem?.semester {
                return "Semester " + String(s)
                }
            else {
                return ""
                }
        }
        semesterLabel.text = semesterArray?.joined(separator: " - ")
        classDetailsText.text = course?.moduleDescription
        preclusionLabel.text = "Preclusion"
        preclusionText.text = course?.preclusion
        let semesterExamArray = course?.semesterData?.semesterData.map { sem -> String in
            var str = ""
            if let d = sem?.examDate {
                str += d + " , "
            }
            if let dur = sem?.examDuration {
                str += String(dur)
            }
            return str
        }
        if (semesterExamArray?[0]) != nil {
            semester1ExamLabel.text =  "Semester 1 Exam"
        }
        
        if (semesterExamArray?[1]) != nil {
            semester2ExamLabel.text =  "Semester 2 Exam"
        }
        semester1ExamText.text = semesterExamArray?[0] ?? ""
        semester2ExamText.text = semesterExamArray?[1] ?? ""
    }
    
// MARK:- Actions
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func addToScheduleTapped(_ sender: Any) {
        let user = Auth.auth().currentUser
               if let user = user {
                   let uid = user.uid
                dataSource.addCourseToSchedule(uid: uid, course: course)
               }
        self.dismiss(animated: true, completion: nil)
    }
    

}
