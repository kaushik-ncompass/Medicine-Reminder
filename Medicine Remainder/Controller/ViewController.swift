//
//  ViewController.swift
//  Medicine Remainder
//
//  Created by Kaushik on 11/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var reminderTableView: UITableView!
    @IBOutlet weak var emptyStateView: UIView!
    @IBOutlet weak var headerText: UILabel!
    
    let userDefaults = UserDefaults.standard
    
    var selectedIndexPath: Int!
    var users: User!
    var members = [Member]()
    var isEdit: Bool = false
    var notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        configureTable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isEdit {
            UIView.transition(with: self.view, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.members = self.retrieveAllObjects()!
                self.reloadTable()
                self.isEdit = false
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func configureTable() {
        if let checkForData = retrieveAllObjects() {
            members = checkForData
            if checkForData.count > 0 {
                UIView.transition(with: emptyStateView, duration: 0.4,
                                  options: .transitionCrossDissolve,
                                  animations: {
                    self.emptyStateView.isHidden = true
                    self.headerText.isHidden = false
                })
            } else {
                self.headerText.isHidden = true
            }
        } else {
            self.headerText.isHidden = true
        }
        self.users = User.instance(members: self.members)
    }

    func reloadTable() {
        users = User.instance(members: members)
        self.reminderTableView.reloadData()
    }
    
    func retrieveAllObjects() -> [Member]? {
        if let objects = userDefaults.value(forKey: "user") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(Array.self, from: objects) as [Member] {
                return loadedPerson
            }
        }
        return nil
     }
    
    func saveAllObjects(allObjects: [Member]) {
          let encoder = JSONEncoder()
          if let encoded = try? encoder.encode(allObjects){
             UserDefaults.standard.set(encoded, forKey: "user")
              UserDefaults.standard.synchronize()
          }
     }
    
    func editReminder(indexPath: Int, timeStamp: String) {
        let result = self.retrieveAllObjects()
        let member = result![indexPath]
        
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
        vc.userIndex = indexPath
        vc.isEdit = true
        vc.editTimeStamp = timeStamp
        
        self.navigationController?.pushViewController(vc, animated: true)
        isEdit = true
    }
    
    func deleteReminder(indexPath: Int, timeStamp: String) {
        self.members.remove(at: indexPath)
        self.saveAllObjects(allObjects: self.members)
        reloadTable()
        if members.count == 0 {
            UIView.transition(with: emptyStateView, duration: 0.4,
                              options: .transitionCrossDissolve,
                              animations: {
                self.emptyStateView.isHidden = false
                self.headerText.isHidden = true
            })
        }
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [timeStamp])
        InAppNotification.show(message: "Deleted the reminder successfully", image: #imageLiteral(resourceName: "toast_tick"), decayIn: 2, position: .bottom)
    }

    @IBAction func addReminderButtonTapped(_ sender: UIButton) {

        guard let vc = storyboard?.instantiateViewController(withIdentifier: "addRemainder") as? AddRemainderViewController else { return }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { memberName, medicineName, doseTimings, schedule, diagnosis, startDate, remindMe, timeStamp in
            DispatchQueue.main.async {
                let member = Member(memberName: memberName, medicineName: medicineName, doseTimings: doseTimings, schedule: schedule, diagnosis: diagnosis, startDate: startDate, remindme: remindMe, timeStamp: timeStamp)
                self.members.append(member)
                self.reloadTable()
                self.saveAllObjects(allObjects: self.members)
                if let checkForData = self.retrieveAllObjects() {
                    if checkForData.count > 0 {
                        UIView.transition(with: self.emptyStateView, duration: 0.4,
                                          options: .transitionCrossDissolve,
                                          animations: {
                            self.emptyStateView.isHidden = true
                            self.headerText.isHidden = false
                        })
                    }
                }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140
    }
}
