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
    var dataSource = ClassSearchDataSource()
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
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var detailTextFieldHeightAnchor: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButton.layer.cornerRadius = 55/2
        
        dataSource.delegate = self
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
        configureDetailTFHeight(detailText)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addButton.alpha = 0.6
        self.addButton.isEnabled = false
        if let courseDetail = course, let moduleCode = course?.moduleCode {
            dataSource.loadCourseDetail(moduleCode: moduleCode, course: courseDetail)
        }
        self.addButton.isEnabled = false
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
    
    // MARK:- Helpers
    func configureDetailTFHeight(_ detailText: String?) {
        let textFieldWidth = view.frame.width - 40
        let textFieldFont = classDetailsText.font ?? UIFont.systemFont(ofSize: 14)
        if let text = detailText {
            detailTextFieldHeightAnchor.constant = text.height(withConstrainedWidth: textFieldWidth,
                                                               font: textFieldFont) + 16
        } else {
            detailTextFieldHeightAnchor.constant = 16
        }
        view.layoutIfNeeded()
    }
}

// MARK:- ClassSearchDataSource Delegate
extension SearchedClassDetailViewController: ClassSearchDataSourceDelegate {
    func courseDetailLoaded() {
        self.addButton.isEnabled = true
        self.addButton.alpha = 1
    }
}
