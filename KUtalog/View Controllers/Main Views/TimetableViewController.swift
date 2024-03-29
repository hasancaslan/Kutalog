//
//  TimetableViewController.swift
//  KUtalog
//
//  Created by HASAN CAN on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import UIKit
import KVKCalendar
import CoreData
import FirebaseAuth

extension TimetableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            dataSource.loadSchedule(uid: uid)
        }
    }
}

extension TimetableViewController: TimetableDataSourceDelegate {
    func scheduleLoaded(schedule: Schedule?) {
        if let courses = schedule?.courses?.allObjects as? [Course]? {
            scheduledClassesList = courses
            loadEvents { [unowned self] (events) in
                self.events = events
            }
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
    }
}

final class TimetableViewController: UIViewController {
    private var events = [Event]()
    var scheduledClassesList: [Course]?
    var courseToSendToDetails: Course?
    private lazy var dataSource: TimetableDataSource = {
        let source = TimetableDataSource()
        source.fetchedResultsControllerDelegate = self
        source.delegate = self
        return source
    }()
    private var selectDate: Date = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.date(from: "16.09.2019") ?? Date()
    }()
    private lazy var todayButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "Today", style: .done, target: self, action: #selector(today))
        button.tintColor = .red
        return button
    }()
    private lazy var calendarView: CalendarView = {
        var style = Style()
        style.monthStyle.isHiddenSeporator = true
        style.timelineStyle.widthTime = 40
        style.timelineStyle.offsetTimeX = 2
        style.timelineStyle.offsetLineLeft = 2
        style.followInInterfaceStyle = true
        style.timelineStyle.offsetTimeY = 80
        style.timelineStyle.offsetEvent = 3
        style.timelineStyle.currentLineHourWidth = 40
        style.allDayStyle.isPinned = true
        style.startWeekDay = .monday
        style.timeHourSystem = .twelveHour
        let calendar = CalendarView(frame: view.frame, date: selectDate, style: style)
        calendar.delegate = self
        calendar.dataSource = self
        return calendar
    }()
    private lazy var segmentedControl: UISegmentedControl = {
        let array: [CalendarType]
        if UIDevice.current.userInterfaceIdiom == .pad {
            array = CalendarType.allCases
        } else {
            array = CalendarType.allCases.filter({ $0 != .year })
        }
        let control = UISegmentedControl(items: array.map({ $0.rawValue.capitalized }))
        control.tintColor = .red
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(switchCalendar), for: .valueChanged)
        return control
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(calendarView)
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = todayButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            dataSource.loadSchedule(uid: uid)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var frame = view.frame
        frame.origin.y = 0
        calendarView.reloadFrame(frame)
    }

    @objc func today(sender: UIBarButtonItem) {
        calendarView.scrollToDate(date: Date())
    }

    @objc func switchCalendar(sender: UISegmentedControl) {
        guard let type = CalendarType(rawValue: CalendarType.allCases[sender.selectedSegmentIndex].rawValue) else { return }
        switch type {
        case .day:
            calendarView.set(type: .day, date: selectDate)
        case .week:
            calendarView.set(type: .week, date: selectDate)
        case .month:
            calendarView.set(type: .month, date: selectDate)
        case .year:
            calendarView.set(type: .year, date: selectDate)
        }
        calendarView.reloadData()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        loadEvents { [unowned self] (events) in
            self.events = events
            self.calendarView.reloadData()
        }
    }

    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ScheduledClassViewController {
            destination.course = courseToSendToDetails
        }
    }
}

extension TimetableViewController: CalendarDelegate {
    func didSelectDate(date: Date?, type: CalendarType, frame: CGRect?) {
        selectDate = date ?? Date()
        calendarView.reloadData()
    }

    func didSelectEvent(_ event: Event, type: CalendarType, frame: CGRect?) {
        guard let scheduledCourses = scheduledClassesList else { return }
        for course in scheduledCourses {
            if course.moduleCode == (event.id as! String) {
                self.courseToSendToDetails = course
            }
        }
        performSegue(withIdentifier: "showDetail", sender: event)
    }
}

extension TimetableViewController: CalendarDataSource {
    func eventsForCalendar() -> [Event] {
        return events
    }
}

extension TimetableViewController {
    func loadEvents(completion: ([Event]) -> Void) {
        var events = [Event]()
        guard let scheduledCourses = scheduledClassesList else { return }
        for course in scheduledCourses {
            let index = Double(scheduledCourses.firstIndex(of: course) ?? 0)
            let colorCount = Double(CellColors.backgrounColors.count)
            let colorIndex = Int(index.truncatingRemainder(dividingBy: colorCount))
            let color = CellColors.backgrounColors[colorIndex]
            let weekday = course.semesterData?.semesterData.first??.timetable?.first??.day
            var startDateString = "13.09.2019"
            var endDateString = "13.09.2019"
            if let startTime = course.semesterData?.semesterData.first??.timetable?.first??.startTime,
                let endTime = course.semesterData?.semesterData.first??.timetable?.first??.endTime {
                startDateString = "13.09.2019\(startTime)00"
                endDateString = "13.09.2019\(endTime)00"
            } else {
                startDateString += "000000"
                endDateString += "000000"
            }
            var start = self.formatter(date: startDateString)
            var end = self.formatter(date: endDateString)
            for _ in 0...13 {
                var event = Event()
                switch weekday {
                case "Monday":
                    start = start.next(.monday)
                    end = end.next(.monday)
                    event.start = start
                    event.end = end
                case "Tuesday":
                   start = start.next(.tuesday)
                    end = end.next(.tuesday)
                    event.start = start
                    event.end = end
                case "Wednesday":
                    start = start.next(.wednesday)
                    end = end.next(.wednesday)
                    event.start = start
                    event.end = end
                case "Thursday":
                    start = start.next(.thursday)
                    end = end.next(.thursday)
                    event.start = start
                    event.end = end
                case "Friday":
                   start = start.next(.friday)
                    end = end.next(.friday)
                    event.start = start
                    event.end = end
                default:
                    event.start = start
                    event.end = end
                }
                event.id = course.moduleCode as Any
                event.color = EventColor(color)
                event.isAllDay = false
                event.textForMonth = "\(course.moduleCode ?? "")"
                event.text = "\(course.moduleCode ?? "")"
                events.append(event)
            }
        }
        completion(events)
    }

    func formatter(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyyHHmmss"
        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter.date(from: date) ?? Date()
    }
}
