//
//  Class.swift
//  KUtalog
//
//  Created by Ceren on 5.12.2019.
//  Copyright © 2019 cerenhasancan. All rights reserved.
//

import Foundation

struct SemesterData: Codable {
    let semester: Int?
    let examDate: String?
    let examDuration: Int?
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

enum Workload: Codable {
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
}

enum WorkloadItem: Codable {
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
}
