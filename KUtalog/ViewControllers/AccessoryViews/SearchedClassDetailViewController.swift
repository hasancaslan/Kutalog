//
//  SearchedClassDetailViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit


class SearchedClassDetailViewController: UIViewController {
    let classSearchDataSource = ClassSearchDataSource()
    var module: Module?
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
        classCodeLabel.text = module?.moduleCode
        classNameLabel.text = module?.title
        firstInfoLineLabel.text = "\(module?.department ?? "") - \(module?.faculty ?? "")"
        let semesterArray = module?.semesterData.map { sem -> String in
            if let s = sem?.semester {
                return "Semester " + String(s)
                }
            else {
                return ""
                }
        }
        semesterLabel.text = semesterArray?.joined(separator: " - ")
        classDetailsText.text = module?.description
        preclusionLabel.text = "Preclusion"
        preclusionText.text = module?.preclusion
        let semesterExamArray = module?.semesterData.map { sem -> String in
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
    @IBAction func dismissButton(_ sender: Any) {
        self.dismiss(animated: true) {
            
        }
    }
    

}
