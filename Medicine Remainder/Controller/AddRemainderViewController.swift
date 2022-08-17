//
//  AddRemainderViewController.swift
//  Medicine Remainder
//
//  Created by Kaushik on 11/08/22.
//

import Foundation
import UIKit
import iOSDropDown

class AddRemainderViewController: UIViewController {
    

    @IBOutlet weak var reminderStackViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var reminderStackView: UIStackView!
    @IBOutlet weak var selectMemberTextField: DropDown!
    @IBOutlet weak var medicineNameTextField: UITextField!
    @IBOutlet weak var diagnosisTextField: UITextField!
    @IBOutlet weak var pillCountTextField: UITextField!
    @IBOutlet weak var datePickerTextField: UITextField!
    @IBOutlet weak var medicineRoutineTextField: DropDown!
    @IBOutlet weak var remindMeTextField: DropDown!
    @IBOutlet weak var dose1TextField: UITextField!
    @IBOutlet weak var dose2BgView: UIView!
    @IBOutlet weak var dose2TextField: UITextField!
    @IBOutlet weak var dose3BgView: UIView!
    @IBOutlet weak var dose3TextField: UITextField!
    @IBOutlet weak var addReminderButton: UIButton!
    
    let selectMemberFloatingLabel = UILabel()
    let medicineNameFloatingLabel = UILabel()
    let diagnosisFloatingLabel = UILabel()
    let pillCountFloatingLabel = UILabel()
    let datePickerFloatingLabel = UILabel()
    let medicineRoutineFloatingLabel = UILabel()
    let remindMeFloatingLabel = UILabel()
    let dose1FloatingLabel = UILabel()
    let dose2FloatingLabel = UILabel()
    let dose3FloatingLabel = UILabel()
    let timePickerForDose1 = UIDatePicker()
    let timePickerForDose2 = UIDatePicker()
    let timePickerForDose3 = UIDatePicker()
    let notificationCenter = UNUserNotificationCenter.current()

    var date1 = ""
    var date2 = ""
    var date3 = ""
    var newTime1 = ""
    var newTime2 = ""
    var newTime3 = ""
    
    var editMemberName: String!
    var editMedicineName: String!
    var editDoseTimings: String!
    var editSchedule: String!
    var editDiagnosis: String!
    var editRemindMe: String!
    var editStartDate: String!
    var editUsers: [Member]!
    var userIndex: Int!
    var isEdit: Bool = false
    var reload: (() -> Void)!
    
    public var completion: ((String, String, String, String, String, String, String, Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        self.datePickerTextField.datePicker(target: self,
                                  doneAction: #selector(doneAction),
                                  cancelAction: #selector(cancelAction),
                                  datePickerMode: .date)

        createFloatingLabel()
        createDropDown()
        setValuesToEdit()
        
        if let myImage = UIImage(named: "timer"){
            dose1TextField.withImage(image: myImage)
            dose2TextField.withImage(image: myImage)
            dose3TextField.withImage(image: myImage)
        }
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if(!granted) {
                print("Permission Denied")
            }
        }
    }
    
    @objc
    func cancelAction() {
        self.datePickerTextField.resignFirstResponder()
    }

    @objc
    func doneAction() {
        if let datePickerView = self.datePickerTextField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = dateFormatter.string(from: datePickerView.date)
            self.datePickerTextField.text = dateString
            self.datePickerTextField.resignFirstResponder()
        }
    }
    
    func createDatePicker(textField: UITextField, timePicker: UIDatePicker) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        if textField.largeContentTitle! == "Dose 1 at" {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
            configureDatePicker(doneBtn: doneBtn, toolbar: toolbar, textField: textField, timePicker: timePickerForDose1)
        } else if textField.largeContentTitle! == "Dose 2 at" {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
            configureDatePicker(doneBtn: doneBtn, toolbar: toolbar, textField: textField, timePicker: timePickerForDose2)
        } else if textField.largeContentTitle! == "Dose 3 at" {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed3))
            configureDatePicker(doneBtn: doneBtn, toolbar: toolbar, textField: textField, timePicker: timePickerForDose3)
        }
        timePicker.datePickerMode = .countDownTimer
    }
    
    func configureDatePicker(doneBtn: UIBarButtonItem,toolbar: UIToolbar, textField: UITextField, timePicker: UIDatePicker) {
        toolbar.setItems([doneBtn], animated: true)
        textField.inputView = timePicker
        textField.inputAccessoryView = toolbar
    }
    
    func createDropDown() {
        selectMemberTextField.optionArray = ["Tony Stark","Peter Parker","Steve Rogers", "Bruce Banner", "Natasha"]
        selectMemberTextField.didSelect{(selectedText , index ,id) in
            self.selectMemberTextField.text = "\(selectedText)"
        }
        configureDropDown(textField: selectMemberTextField)
        
        medicineRoutineTextField.optionArray = ["Daily", "Weekly"]
        medicineRoutineTextField.didSelect{(selectedText , index ,id) in
            self.medicineRoutineTextField.text = "\(selectedText)"
        }
        configureDropDown(textField: medicineRoutineTextField)
        
        remindMeTextField.optionArray = ["1 time a day", "2 times a day", "3 times a day"]
        remindMeTextField.didSelect{(selectedText , index ,id) in
            self.remindMeTextField.text = "\(selectedText)"
            self.updateDoseFields()
        }
        configureDropDown(textField: remindMeTextField)
    }
    
    func configureDropDown(textField: DropDown) {
        textField.arrowSize = 10
        textField.arrowColor = .black
        textField.checkMarkEnabled = false
        textField.selectedRowColor = .white
    }
    
    func setValuesToEdit() {
        if isEdit {
            selectMemberTextField.text = editMemberName
            medicineRoutineTextField.text = editSchedule
            diagnosisTextField.text = editDiagnosis
            remindMeTextField.text = editRemindMe
            datePickerTextField.text = editStartDate
            self.updateDoseFields()

            selectMemberFloatingLabel.isHidden = false
            selectMemberFloatingLabel.text = selectMemberTextField.placeholder
            
            diagnosisFloatingLabel.isHidden = false
            diagnosisFloatingLabel.text = diagnosisTextField.placeholder
            
            datePickerFloatingLabel.isHidden = false
            datePickerFloatingLabel.text = datePickerTextField.placeholder
            
            medicineRoutineFloatingLabel.isHidden = false
            medicineRoutineFloatingLabel.text = medicineRoutineTextField.placeholder
            
            remindMeFloatingLabel.isHidden = false
            remindMeFloatingLabel.text = remindMeTextField.placeholder
            
            let splitTimes = editDoseTimings.components(separatedBy: " - ")
            let medicines = editMedicineName.components(separatedBy: " - ")
            
            pillCountTextField.text = medicines[0]
            pillCountFloatingLabel.isHidden = false
            pillCountFloatingLabel.text = pillCountTextField.placeholder
            
            medicineNameTextField.text = medicines[1]
            medicineNameFloatingLabel.isHidden = false
            medicineNameFloatingLabel.text = medicineNameTextField.placeholder

            if splitTimes.count == 1 {
                dose1TextField.text! = splitTimes[0]
                dose1FloatingLabel.isHidden = false
                dose1FloatingLabel.text = dose1TextField.placeholder
            }
            if splitTimes.count == 2 {
                dose1TextField.text! = splitTimes[0]
                dose1FloatingLabel.isHidden = false
                dose1FloatingLabel.text = dose1TextField.placeholder
                dose2TextField.text! = splitTimes[1]
                dose2FloatingLabel.isHidden = false
                dose2FloatingLabel.text = dose2TextField.placeholder
            }
            if splitTimes.count == 3 {
                dose1TextField.text! = splitTimes[0]
                dose1FloatingLabel.isHidden = false
                dose1FloatingLabel.text = dose1TextField.placeholder
                dose2TextField.text! = splitTimes[1]
                dose2FloatingLabel.isHidden = false
                dose2FloatingLabel.text = dose2TextField.placeholder
                dose3TextField.text! = splitTimes[2]
                dose3FloatingLabel.isHidden = false
                dose3FloatingLabel.text = dose3TextField.placeholder
            }
        }
    }
    
    @objc func donePressed1(sender: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePickerForDose1.date).lowercased()
        self.dose1TextField.text = dateString
        self.newTime1 = dateString
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: -5, to: timePickerForDose1.date)!
        date1 = formatter.string(from: newDate).lowercased()
        self.view.endEditing(true)
    }
    
    @objc func donePressed2(sender: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePickerForDose2.date).lowercased()
        self.dose2TextField.text = dateString
        self.newTime2 = dateString
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: -5, to: timePickerForDose2.date)!
        date2 = formatter.string(from: newDate).lowercased()
        self.view.endEditing(true)
    }
    
    @objc func donePressed3(sender: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePickerForDose3.date).lowercased()
        self.dose3TextField.text = dateString
        self.newTime3 = dateString
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: -5, to: timePickerForDose3.date)!
        date3 = formatter.string(from: newDate).lowercased()
        self.view.endEditing(true)
    }
    
    func doneActionForDoseTimings(timePicker: UIDatePicker, textField: UITextField) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePicker.date).lowercased()
        textField.text = dateString
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: -5, to: timePicker.date)!
        date3 = formatter.string(from: newDate).lowercased()
        self.view.endEditing(true)
        
        return dateString
    }
    
    func updateDoseFields() {
        if self.remindMeTextField.text == "1 time a day" {
            self.dose2BgView.isHidden = true
            self.dose3BgView.isHidden = true
            self.reminderStackViewHeightConstraint.constant = 338
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            dose2TextField.text = ""
            dose3TextField.text = ""
        } else if self.remindMeTextField.text == "2 times a day" {
            self.dose2BgView.isHidden = false
            self.dose3BgView.isHidden = true
            self.reminderStackViewHeightConstraint.constant = 392
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            dose3TextField.text = ""
        } else {
            self.reminderStackViewHeightConstraint.constant = 450
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            self.dose2BgView.isHidden = false
            self.dose3BgView.isHidden = false
        }
    }
    
    func createFloatingLabel() {
        customizeFloatingLabel(floatingPlaceHolder: selectMemberFloatingLabel, textField: selectMemberTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: medicineNameFloatingLabel, textField: medicineNameTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: diagnosisFloatingLabel, textField: diagnosisTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: pillCountFloatingLabel, textField: pillCountTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: datePickerFloatingLabel, textField: datePickerTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: medicineRoutineFloatingLabel, textField: medicineRoutineTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: remindMeFloatingLabel, textField: remindMeTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: dose1FloatingLabel, textField: dose1TextField)
        
        customizeFloatingLabel(floatingPlaceHolder: dose2FloatingLabel, textField: dose2TextField)
        
        customizeFloatingLabel(floatingPlaceHolder: dose3FloatingLabel, textField: dose3TextField)
    }
    
    func customizeFloatingLabel(floatingPlaceHolder: UILabel, textField: UITextField) {
        floatingPlaceHolder.frame = CGRect(x: 16, y: 9, width: 500, height: 20)
        floatingPlaceHolder.font = UIFont.systemFont(ofSize: 12)
        floatingPlaceHolder.textColor = UIColor(named: "floatingLabel")
        textField.addSubview(floatingPlaceHolder)
    }
    
    func notification(memberName: String, medicineName: String, time1: String, time2: String, time3: String, startDate: String, interval: String) {
        
        notificationCenter.delegate = self
        
        let doseTimings = [time1, time2, time3]
        let notificationTimings = [newTime1, newTime2, newTime3]
        
        for (time,newTime) in zip(doseTimings,notificationTimings) {
            if time != "" && newTime != "" {
                let min = time[3...4]
                let hour = time[0...1]
                let day = startDate[0...1]
                let month = startDate[3...4]
                let year = startDate[6...9]
                
                var dateComponents = DateComponents()
                dateComponents.year = Int(year)
                dateComponents.month = Int(month)
                dateComponents.day = Int(day)
                if interval != "Daily" {
                    dateComponents.weekday = formattedDate(dateString: startDate)
                }
                dateComponents.hour = Int(hour)
                dateComponents.minute = Int(min)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let content = UNMutableNotificationContent()
                content.title = "Medicine reminder"
                content.body = " Hi \(memberName), Please take your \(medicineName) at \(newTime)"
                content.sound = .default
                
                let randomIdentifier = UUID().uuidString
                let request = UNNotificationRequest(identifier: randomIdentifier, content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if error != nil {
                        print("something went wrong")
                    }
                }
            }
        }
    }
    
    func formattedDate(dateString: String) -> Int
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from:dateString)!
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .weekday], from: date)
        let weekday = components.weekday!
        _ = calendar.date(from:components)!
        
        return weekday
    }
    
    @IBAction func addReminderPressed(_ sender: UIButton) {
        notification(memberName: selectMemberTextField.text!, medicineName: medicineNameTextField.text!, time1: date1,time2: date2, time3: date3, startDate: datePickerTextField.text!, interval: medicineRoutineTextField.text!)
        self.navigationController?.popViewController(animated: true)
        var doseTimings = dose1TextField.text!
        if dose2TextField.text! != "" {
            doseTimings += " - \(dose2TextField.text!)"
            if dose3TextField.text! != "" {
                doseTimings += " - \(dose3TextField.text!)"
            }
        }
        if isEdit{
            editUsers[userIndex] = Member(memberName: selectMemberTextField.text!, medicineName:  "\(pillCountTextField.text!) - \(medicineNameTextField.text!)", doseTimings: doseTimings, schedule: medicineRoutineTextField.text!, diagnosis: diagnosisTextField.text!, startDate: datePickerTextField.text!, remindme: remindMeTextField.text!)
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(editUsers){
                UserDefaults.standard.set(encoded, forKey: "user")
            }
            reload
        }
        completion?(selectMemberTextField.text!, "\(pillCountTextField.text!) - \(medicineNameTextField.text!)", doseTimings, medicineRoutineTextField.text!, diagnosisTextField.text!, datePickerTextField.text!, remindMeTextField.text!, isEdit)
    }
}

extension AddRemainderViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        if textField == self.selectMemberTextField
        {
            let text = (selectMemberTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                selectMemberFloatingLabel.isHidden = false
                selectMemberFloatingLabel.text = selectMemberTextField.placeholder
            } else {
                selectMemberFloatingLabel.isHidden = true
                self.selectMemberTextField.placeholder = "Select Member"
            }
        } else if textField == self.medicineNameTextField {
            let text = (medicineNameTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                medicineNameFloatingLabel.isHidden = false
                medicineNameFloatingLabel.text = medicineNameTextField.placeholder
            } else {
                medicineNameFloatingLabel.isHidden = true
                self.medicineNameTextField.placeholder = "Medicine Name"
            }
        } else if textField == self.diagnosisTextField {
            let text = (diagnosisTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                diagnosisFloatingLabel.isHidden = false
                diagnosisFloatingLabel.text = diagnosisTextField.placeholder
            } else {
                diagnosisFloatingLabel.isHidden = true
                self.diagnosisTextField.placeholder = "Diagnosis"
            }
        } else if textField == self.pillCountTextField {
            let text = (pillCountTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                pillCountFloatingLabel.isHidden = false
                pillCountFloatingLabel.text = pillCountTextField.placeholder
            } else {
                pillCountFloatingLabel.isHidden = true
                self.pillCountTextField.placeholder = "No of Pills/ Units"
            }
        } else if textField == self.datePickerTextField {
            let text = (datePickerTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                datePickerFloatingLabel.isHidden = false
                datePickerFloatingLabel.text = datePickerTextField.placeholder
            }
            else {
                datePickerFloatingLabel.isHidden = true
                self.datePickerTextField.placeholder = "Start Date"
            }
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.selectMemberTextField {
            selectMemberTextField.showList()
            selectMemberFloatingLabel.isHidden = false
            selectMemberFloatingLabel.text = self.selectMemberTextField.placeholder
        }
        if textField == self.medicineNameTextField {
            medicineNameFloatingLabel.isHidden = false
            medicineNameFloatingLabel.text = medicineNameTextField.placeholder
        }
        if textField == self.diagnosisTextField {
            diagnosisFloatingLabel.isHidden = false
            diagnosisFloatingLabel.text = diagnosisTextField.placeholder
        }
        if textField == self.pillCountTextField {
            pillCountFloatingLabel.isHidden = false
            pillCountFloatingLabel.text = pillCountTextField.placeholder
        }
        if textField == self.datePickerTextField {
            datePickerFloatingLabel.isHidden = false
            datePickerFloatingLabel.text = datePickerTextField.placeholder
        }
        if textField == self.medicineRoutineTextField {
            medicineRoutineTextField.showList()
            medicineRoutineFloatingLabel.isHidden = false
            medicineRoutineFloatingLabel.text = medicineRoutineTextField.placeholder
        }
        if textField == self.remindMeTextField {
            remindMeTextField.showList()
            remindMeFloatingLabel.isHidden = false
            remindMeFloatingLabel.text = remindMeTextField.placeholder
        }
        if textField == self.dose1TextField {
            createDatePicker(textField: dose1TextField, timePicker: timePickerForDose1)
            dose1FloatingLabel.isHidden = false
            dose1FloatingLabel.text = dose1TextField.placeholder
        }
        if textField == self.dose2TextField {
            createDatePicker(textField: dose2TextField, timePicker: timePickerForDose2)
            dose2FloatingLabel.isHidden = false
            dose2FloatingLabel.text = dose2TextField.placeholder
        }
        if textField == self.dose3TextField {
            createDatePicker(textField: dose3TextField, timePicker: timePickerForDose3)
            dose3FloatingLabel.isHidden = false
            dose3FloatingLabel.text = dose3TextField.placeholder
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.datePickerTextField {
            datePickerTextField.placeholder = "Start Date"
        } else if textField == self.medicineRoutineTextField {
            medicineRoutineTextField.placeholder = "Medicine Routine"
        } else if textField == self.remindMeTextField {
            remindMeTextField.placeholder = "Remind me"
        } else if textField == self.dose1TextField {
            dose1TextField.placeholder = "Dose 1 at"
        } else if textField == self.dose2TextField {
            dose2TextField.placeholder = "Dose 2 at"
        } else if textField == self.dose3TextField {
            dose3TextField.placeholder = "Dose 3 at"
        }
    }
}

extension UITextField {
    
    func datePicker<T>(target: T,
                       doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date) {
        let screenWidth = UIScreen.main.bounds.width
        
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()
            
            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style,
                                                target: buttonTarget,
                                                action: action)
            
            return barButtonItem
        }
        
        let datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: screenWidth,
                                                    height: 216))
        datePicker.datePickerMode = datePickerMode
        self.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0,
                                              y: 0,
                                              width: screenWidth,
                                              height: 44))
        toolBar.backgroundColor = .white
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}

class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 26,
        left: 11,
        bottom: 10,
        right: 20
    )
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}

extension UITextField {
    
    func withImage(image: UIImage){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
        view.addSubview(imageView)
        
        self.rightViewMode = .always
        self.rightView = mainView
    }
}

extension AddRemainderViewController: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}

extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }

    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
}
