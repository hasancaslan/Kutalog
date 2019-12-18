//
//  TimetableViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import FirebaseAuth
import CoreData

extension TimetableViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.bounds.width - 19) / 20.0
        let cellHeight = (collectionView.bounds.height - 4) /  5.0
        let size = CGSize.init(width: cellWidth, height: cellHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension TimetableViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LandscapeTimetableCollectionViewCell", for: indexPath) as! LandscapeTimetableCollectionViewCell
        
        // We use this variable to get the index of this class's start. If this index is equal to the current index, then we
        // need to add the class code as a label. Cell decides what to do using this label
        let course = grid[indexPath.row]
        let lesson = course?.semesterData?.semesterData.first??.timetable?.first
        let start = lesson??.startTime
        let lessonDay = lesson??.day
        let courseStartIndex = translateStartHourToGridLocation(hour: start ?? "") * translateDaysToGridLocation(day: lessonDay ?? "")
        cell.addClass(course: course ?? nil, addLabel: courseStartIndex == indexPath.row, color: translateDayToColor(day: lessonDay ?? ""))
        return cell
    }
    
}

extension TimetableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredClassesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimetableTableViewCell", for: indexPath) as! TimetableTableViewCell
        cell.configure(course: filteredClassesList?[indexPath.row])
        return cell
    }
    
    
}

extension TimetableViewController: TimetableDataSourceDelegate {
    func scheduleLoaded(schedule: Schedule?) {
        if let courses = schedule?.courses?.allObjects as? [Course]? {
            scheduledClassesList = courses
            timetableTableView.reloadData()
            weeklyScheduleCollectionView.reloadData()
            createGrid()
//            let lesson = scheduledClassesList?.first?.semesterData?.semesterData.first??.timetable?.first
//            print(lesson??.startTime)
//            print(lesson??.endTime)
//            print(lesson??.day)
//            print(scheduledClassesList)
        }
    }
}


class TimetableViewController: UIViewController  {
    // The array for the scheduled classes
    var scheduledClassesList: [Course]?
    var filteredClassesList: [Course]? = [Course]()
    var dataSource = TimetableDataSource()
    // The array we use to create the grid
    var grid = Array<Course?>(repeating: nil, count: 100)
    
    // Outlets For Portrait
    @IBOutlet weak var weekdaysSegmentedControl: UISegmentedControl!
    @IBOutlet weak var timetableTableView: UITableView!
    
    // Outlets For Landscape
    @IBOutlet weak var weeklyScheduleCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            dataSource.loadSchedule(uid: uid)
        }
    }
    @IBAction func segmentIndexChanged(_ sender: Any) {
        switch weekdaysSegmentedControl.selectedSegmentIndex {
        case 0:
            filterClassesList(byDay: "Monday")
            timetableTableView.reloadData()
        case 1:
           filterClassesList(byDay: "Tuesday")
            timetableTableView.reloadData()
        case 2:
           filterClassesList(byDay: "Wednesday")
            timetableTableView.reloadData()
        case 3:
            filterClassesList(byDay: "Thursday")
            timetableTableView.reloadData()
        case 4:
            filterClassesList(byDay: "Friday")
            timetableTableView.reloadData()
        default:
            break
        }
        
    }
    
    func filterClassesList(byDay day: String) {
        filteredClassesList = scheduledClassesList?.filter({ course in
            return course.semesterData?.semesterData.first??.timetable?.first??.day == day
        })
    }
    
    // This function is necessary to stop timetableTableView from updating if the orientation is Landscape
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIApplication.shared.statusBarOrientation.isLandscape {
            // activate landscape changes
            timetableTableView.endUpdates()
            
        } else {
            // activate portrait changes
            timetableTableView.beginUpdates()
        }
    }
    
    func createGrid(){
        for course in scheduledClassesList ?? [] {
            guard let lesson = course.semesterData?.semesterData.first??.timetable?.first else { return }
            guard let start = lesson?.startTime else { return }
            guard let end = lesson?.endTime else { return }
            guard let lessonDay = lesson?.day else { return }
            let startHour = translateStartHourToGridLocation(hour: start)
            let endHour = translateEndHourToGridLocation(hour: end)
            let day = translateDaysToGridLocation(day: lessonDay)
//            guard let appDelegate =
//                UIApplication.shared.delegate as? AppDelegate else {
//                return
//            }
//            let managedContext = appDelegate.persistentContainer.viewContext
//            let course = Course.init(entity: NSEntityDescription.entity(forEntityName: "Course", in: managedContext)!, insertInto: managedContext)
//            print("\(startHour) \(endHour) \(day)")
            if day != -1 && startHour != -1 && endHour != -1 {
                let startIndex = startHour + day * 20
                let endIndex = endHour + day * 20
                for index in startIndex...endIndex{
                    if grid[index] == nil {
                        grid.insert(course, at: index)
                        print("inserted to grid loc \(index)")
                    }
                }
            }
        }
        
    }
    
    
    // TRANSLATING FUNCTIONS:
    // They are used for translating Strings about starting and endin hours, and the day of the class to Integers.
    // These integers are then used for finding the appropriate index for the grid array
    
    func translateDaysToGridLocation(day: String) -> Int {
        switch day {
        case "Monday":
            return 0
        case "Tuesday":
            return 1
        case "Wednesday":
            return 2
        case "Thursday":
            return 3
        case "Friday":
            return 4
        default:
            return -1
        }
    }
    
    func translateStartHourToGridLocation(hour: String) -> Int {
        switch hour {
        case "0800":
            return 0
        case "0830":
            return 1
        case "0900":
            return 2
        case "0930":
            return 3
        case "1000":
            return 4
        case "1030":
            return 5
        case "1100":
            return 6
        case "1130":
            return 7
        case "1200":
            return 8
        case "1230":
            return 9
        case "1300":
            return 10
        case "1330":
            return 11
        case "1400":
            return 12
        case "1430":
            return 13
        case "1500":
            return 14
        case "1530":
            return 15
        case "1600":
            return 16
        case "1630":
            return 17
        case "1700":
            return 18
        case "1730":
            return 19
        default:
            return -1
        }
    }
    
    func translateEndHourToGridLocation(hour: String) -> Int {
        switch hour {
        case "0830":
            return 0
        case "0900":
            return 1
        case "0930":
            return 2
        case "1000":
            return 3
        case "1030":
            return 4
        case "1100":
            return 5
        case "1130":
            return 6
        case "1200":
            return 7
        case "1230":
            return 8
        case "1300":
            return 9
        case "1330":
            return 10
        case "1400":
            return 11
        case "1430":
            return 12
        case "1500":
            return 13
        case "1530":
            return 14
        case "1600":
            return 15
        case "1630":
            return 16
        case "1700":
            return 17
        case "1730":
            return 18
        case "1800":
            return 19
        default:
            return -1
        }
    }
    
    func translateDayToColor(day: String) ->  UIColor {
        if translateDaysToGridLocation(day: day)/2 == 0 {
            return .lightGray
        }
        else {
            return .white
        }
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
