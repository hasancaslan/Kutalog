//
//  Class.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation

class SemesterData: NSObject, Codable, NSCoding {
    let semester: Int?
    let examDate: String?
    let examDuration: Int?
    let timetable: [Lesson?]?
    
    enum Key: String {
        case semester = "semester"
        case examDate = "examDate"
        case examDuration = "examDuration"
        case timetable = "timetable"
    }
    
    init(semester: Int?, examDate: String?, examDuration: Int?, timetable: [Lesson?]?) {
        self.semester = semester
        self.examDate = examDate
        self.examDuration = examDuration
        self.timetable = timetable
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(semester, forKey: Key.semester.rawValue)
        aCoder.encode(examDate, forKey: Key.examDate.rawValue)
        aCoder.encode(examDuration, forKey: Key.examDuration.rawValue)
        aCoder.encode(timetable, forKey: Key.timetable.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mSemester = aDecoder.decodeObject(forKey: Key.semester.rawValue) as? Int
        let mExamDate = aDecoder.decodeObject(forKey: Key.examDate.rawValue) as? String
        let mExamDuration = aDecoder.decodeObject(forKey: Key.examDuration.rawValue) as? Int
        let mTimetable = aDecoder.decodeObject(forKey: Key.timetable.rawValue) as? [Lesson?]
        self.init(semester: mSemester, examDate: mExamDate, examDuration: mExamDuration, timetable: mTimetable)
    }
}

class Lesson: NSObject, Codable, NSCoding {
    let classNo: String?
    let startTime: String?
    let endTime: String?
    let venue: String?
    let day: String?
    let lessonType: String?
    let size: Int?
    
    enum Key: String {
        case classNo = "classNo"
        case startTime = "startTime"
        case endTime = "endTime"
        case venue = "venue"
        case day = "day"
        case lessonType = "lessonType"
        case size = "size"
    }
    
    init(classNo: String?, startTime: String?, endTime: String?, venue: String?, day: String?, lessonType: String?, size: Int?) {
        self.classNo = classNo
        self.startTime = startTime
        self.endTime = endTime
        self.venue = venue
        self.day = day
        self.lessonType = lessonType
        self.size = size
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(classNo, forKey: Key.classNo.rawValue)
        aCoder.encode(startTime, forKey: Key.startTime.rawValue)
        aCoder.encode(endTime, forKey: Key.endTime.rawValue)
        aCoder.encode(venue, forKey: Key.venue.rawValue)
        aCoder.encode(day, forKey: Key.day.rawValue)
        aCoder.encode(lessonType, forKey: Key.lessonType.rawValue)
        aCoder.encode(size, forKey: Key.size.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let classNo = aDecoder.decodeObject(forKey: Key.classNo.rawValue) as? String
        let startTime = aDecoder.decodeObject(forKey: Key.startTime.rawValue) as? String
        let endTime = aDecoder.decodeObject(forKey: Key.endTime.rawValue) as? String
        let venue = aDecoder.decodeObject(forKey: Key.venue.rawValue) as? String
        let day = aDecoder.decodeObject(forKey: Key.day.rawValue) as? String
        let lessonType = aDecoder.decodeObject(forKey: Key.lessonType.rawValue) as? String
        let size = aDecoder.decodeObject(forKey: Key.size.rawValue) as? Int
        self.init(classNo: classNo, startTime: startTime, endTime: endTime, venue: venue, day: day, lessonType: lessonType, size: size)
    }
}

struct Module: Codable {
    let moduleCode: String?
    let title: String?
    let description: String?
    let moduleCredit: String?
    let department: String?
    let faculty: String?
    let preclusion: String?
    let workload: Workload?
    let semesterData: [SemesterData?]
    
    enum CodingKeys: String, CodingKey {
        case moduleCode
        case title
        case description
        case moduleCredit
        case department
        case faculty
        case preclusion
        case workload = "workload"
        case semesterData
    }
}

enum Workload: Codable, CustomStringConvertible {
    case array(Array<WorkloadItem>)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Array<WorkloadItem>.self) {
            self = .array(x)
            return
        }
        throw DecodingError.typeMismatch(Workload.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Workload"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .array(let x):
            try container.encode(x)
        }
    }
    
    var description: String {
        switch self {
        case .array(let x):
            var str = ""
            x.forEach { (a) in
                str += String(describing: a) + " "
            }
            return str
        case .string(let x):
            return x
        }
    }
}

enum WorkloadItem: Codable, CustomStringConvertible {
    case string(String)
    case float(Float)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Float.self) {
            self = .float(x)
            return
        }
        throw DecodingError.typeMismatch(Workload.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Workload"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .float(let x):
            try container.encode(x)
        }
    }
    
    var description: String {
        switch self {
        case .float(let x):
            return String(x)
        case .string(let x):
            return x
        }
    }
}
