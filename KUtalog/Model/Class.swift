//
//  Class.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation

/*extension RawServerResponse: Decodable {

    init(from decoder: Decoder) throws {
        // semesterDataata
        let container = try decoder.container(keyedBy: RootKeys.self)
        moduleCode = try container.decode(String.self, forKey: .moduleCode)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        moduleCredit = try container.decode(String.self, forKey: .moduleCredit)
        faculty = try container.decode(String.self, forKey: .faculty)
        prerequisite = try container.decode(String.self, forKey: .prerequisite)
        preclusion = try container.decode(String.self, forKey: .preclusion)
        corequisite = try container.decode(String.self, forKey: .corequisite)
        //let semesterDatacontainer = try decoder.cont
        //semester = try semesterDatacontainer.decode(Int.self, forKey: .semester)
        //examDate = try semesterDatacontainer.decode(String.self, forKey: .examDate)
        //examDuration = try semesterDatacontainer.decode(Int.self, forKey: .examDuration)
    }

}

struct RawServerResponse {
    
    enum RootKeys: String, CodingKey {
        case moduleCode, title, description, moduleCredit, department, faculty, prerequisite, preclusion, corequisite, SemesterData
    }
    
    enum SemesterDataKeys: String, CodingKey {
        case semester, examDate, examDuration
    }
    
    let moduleCode: String
    let title: String
    let description: String
    let moduleCredit: String
    let department: String
    let faculty: String
    let prerequisite: String
    let preclusion: String
    let corequisite: String
    let semester: Int
    let examDate: String
    let examDuration: Int
}



struct Class:Codable  {
    let moduleCode: String
    let title: String
    let description: String
    let moduleCredit: String
    let department: String
    let faculty: String
    let prerequisite: String
    let preclusion: String
    let corerequisite: String
    let semester: Int
    let examDate: String
    let examDuration: Int
}
*/
