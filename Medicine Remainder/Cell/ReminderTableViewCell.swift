//
//  ReminderTableViewCell.swift
//  Medicine Remainder
//
//  Created by Kaushik on 16/08/22.
//

import UIKit

class ReminderTableViewCell: BaseCell {
    
    @IBOutlet weak var pillImageView: UIImageView!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var medicineName: UILabel!
    @IBOutlet weak var doseTimings: UILabel!
    @IBOutlet weak var schedule: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Edit", handler: { (_) in
            }),
            UIAction(title: "Delete", attributes: .destructive, handler: { (_) in
                print("*******\(self.indexPath.row)")
                self.owner.deleteReminder(indexPath: self.indexPath.row)
                
            })
        ]
    }
    var demoMenu: UIMenu {
        return UIMenu(image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    override func configureCellFor(row: UserRow, owner: ViewController, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        guard let row = row as? ReminderRow else { return }
        print("*****\(indexPath)")
        memberName.text = row.member.memberName
        medicineName.text = row.member.medicineName
        doseTimings.text = row.member.doseTimings
        schedule.text = row.member.schedule
        pillImageView.image = UIImage(named: "capsule")
        editButton.menu = demoMenu
        editButton.showsMenuAsPrimaryAction = true
    }
    @IBAction func editButtonTapped(_ sender: Any) {
        
    }
}
