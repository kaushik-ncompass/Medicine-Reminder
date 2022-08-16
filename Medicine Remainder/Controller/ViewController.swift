//
//  ViewController.swift
//  Medicine Remainder
//
//  Created by Kaushik on 11/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var reminderTableView: UITableView!
    
    let userDefaults = UserDefaults.standard
    
    var selectedIndexPath: Int!
    var users: User!
    var members = [Member]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        members = retrieveAllObjects()
        users = User.instance(members: members)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    func configureTableView() {
        users = User.instance(members: members)
        self.reminderTableView.reloadData()
    }
    
    func retrieveAllObjects() -> [Member] {
        if let objects = userDefaults.value(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(Array.self, from: objects) as [Member] {
                return loadedPerson
            }
        }
        return [Member(memberName: "", medicineName: "", doseTimings: "", schedule: "", diagnosis: "", startDate: "", remindme: "")]
     }
    
    func saveAllObjects(allObjects: [Member]) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(allObjects){
             UserDefaults.standard.set(encoded, forKey: "user")
              UserDefaults.standard.synchronize()
          }
     }
    
//    func reminderIndex(index: Int) {
//        self.users.remove(at: index)
//    }
    
    func editReminder(indexPath: Int) {
        var result = self.retrieveAllObjects()
        var member = result[indexPath]
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "addRemainder") as? AddRemainderViewController else { return }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.editMemberName = member.memberName
        vc.editMedicineName = member.medicineName
        vc.editDoseTimings = member.doseTimings
        vc.editSchedule = member.schedule
        vc.editDiagnosis = member.diagnosis
        vc.editRemindMe = member.remindme
        vc.editStartDate = member.startDate
        vc.editUsers = self.members
        vc.userIndex = self.selectedIndexPath
        vc.isEdit = true
        vc.reload = {
            self.reminderTableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func deleteReminder(indexPath: Int) {
        self.members.remove(at: indexPath)
        self.saveAllObjects(allObjects: self.members)
        configureTableView()
//        self.reminderTableView.reloadData()
    }

    @IBAction func addReminderButtonTapped(_ sender: UIButton) {

        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addRemainder") as? AddRemainderViewController else { return }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { memberName, medicineName, doseTimings, schedule, diagnosis, startDate, remindMe, isEdit in
            DispatchQueue.main.async {
                let member = Member(memberName: memberName, medicineName: medicineName, doseTimings: doseTimings, schedule: schedule, diagnosis: diagnosis, startDate: startDate, remindme: remindMe)
                self.members.append(member)
                self.configureTableView()
                self.saveAllObjects(allObjects: self.members)
//                self.users = self.retrieveAllObjects()
//                if isEdit {
//                    self.users = self.retrieveAllObjects()
//                    print("*******\(self.users)")
//                    self.reminderTableView.reloadData()
//                }
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.sections[section].rows.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return users.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = users.sections[indexPath.section].rows[indexPath.row]
        let cell = reminderTableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCellId", for: indexPath) as! ReminderTableViewCell
        cell.configureCellFor(row: row, owner: self, indexPath: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("*******\(indexPath)")
    }
}
