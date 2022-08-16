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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func editButtonTapped(_ sender: UIButton) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
    }
    
    override func configureCellFor(row: UserRow, owner: ViewController, indexPath: IndexPath) {
        super.configureCellFor(row: row, owner: owner, indexPath: indexPath)
        guard let row = row as? ReminderRow else { return }
        print("*****\(row.member)")
        memberName.text = row.member.memberName
        medicineName.text = row.member.medicineName
        doseTimings.text = row.member.doseTimings
        schedule.text = row.member.schedule
        pillImageView.image = UIImage(named: "capsule")
    }
}
