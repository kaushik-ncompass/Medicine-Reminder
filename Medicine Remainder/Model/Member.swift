//
//  Member.swift
//  Medicine Remainder
//
//  Created by Kaushik on 14/08/22.
//

import Foundation

struct Member: Codable {
    var memberName: String
    var medicineName: String
    var doseTimings: String
    var schedule: String
    var diagnosis: String
    var startDate: String
    var remindme: String
}
