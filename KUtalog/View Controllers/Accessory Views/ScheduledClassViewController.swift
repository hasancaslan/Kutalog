//
//  ScheduledClassViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit

class ScheduledClassViewController: UIViewController {

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
    
    var course: Course?
    
    
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
            let detailText = course?.moduleDescription
            classDetailsText.text = detailText
            preclusionText.text = course?.preclusion
            let semesterExamArray = course?.semesterData?.semesterData.map { semester -> String in
                var str = ""
                if let isoDate = semester?.examDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                    let date = dateFormatter.date(from: isoDate)
                    dateFormatter.dateFormat = "dd MMMM yyyy EEEE HH:mm"
                    str += dateFormatter.string(from: date ?? Date())
                }
                if let duration = semester?.examDuration {
                    str = "\(str), \(duration) min"
                }
                return str
            }
            if let semester1Exam = semesterExamArray?.first {
                semester1ExamLabel.text =  "Semester 1 Exam"
                semester1ExamText.text = semester1Exam
            } else {
                semester1ExamLabel.text = nil
                semester1ExamText.text = nil
            }
            if semesterExamArray?.indices.contains(1) ?? false {
                if let semester1Exam = semesterExamArray?[1] {
                    semester2ExamLabel.text =  "Semester 2 Exam"
                    semester2ExamText.text = semester1Exam
                } else {
                    semester2ExamLabel.text = nil
                    semester2ExamText.text = nil
                }
            }
        }
        
        
        // MARK:- Actions
        @IBAction func dismissTapped(_ sender: Any) {
             self.dismiss(animated: true, completion: nil)
        }
        
    }


    
