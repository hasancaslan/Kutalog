//
//  SemesterData.swift
//  KUtalog
//
//  Created by HASAN CAN on 10.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation

public class Semesters: NSObject, NSCoding {
    var semesterData: [SemesterData?] = []
    
    enum Key: String {
        case semesterData = "semesterData"
    }
    
    init(semesterData: [SemesterData?]) {
        self.semesterData = semesterData
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(semesterData, forKey: Key.semesterData.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mSemesters = aDecoder.decodeObject(forKey: Key.semesterData.rawValue) as! [SemesterData?]
        self.init(semesterData: mSemesters)
    }
}
