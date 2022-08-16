//
//  User.swift
//  Medicine Remainder
//
//  Created by Kaushik on 16/08/22.
//

import Foundation
import UIKit

class User {
    var sections: [UserSection]!
    init(sections: [UserSection]) {
        self.sections = sections
    }
}

class UserSection {
    var rows: [UserRow]
    var headerText: String?
    var footerText: String?
    init(title: String? = nil, rows: [UserRow], footerText: String? = nil) {
        self.headerText = title
        self.rows = rows
        self.footerText = footerText
    }
}

class UserRow {
    var reuseIdentifier: String!
    init(reuseIdentifier: String) {
        self.reuseIdentifier = reuseIdentifier
    }
}

class ReminderRow: UserRow {
    var member: Member
    init(reuseIdentifier: String, member: Member) {
        self.member = member
        super.init(reuseIdentifier: reuseIdentifier)
    }
}

extension User {
    static func instance(members: [Member]) -> User {
//        print("*****\(members)")
        var sections = [UserSection]()
        if members.count > 0 {
//            print("***** inside if")
            sections.append(contentsOf: [
                reminderSection(members: members)
            ])
        }
        return User(sections: sections)
    }
    
    static func reminderSection(members: [Member]) -> UserSection {
        var reminderRows = [UserRow]()
        members.forEach { member in
            print("****** Reminder section \(member)")
            reminderRows.append(ReminderRow(reuseIdentifier: "ReminderTableViewCellId", member: member))
        }
        print("****** Reminder Rows \(reminderRows)")
        return UserSection(rows: reminderRows)
    }
}

