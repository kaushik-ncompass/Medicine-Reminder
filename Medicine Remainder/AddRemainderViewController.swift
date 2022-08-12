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
    
    let floatingPlaceHolder1 = UILabel()
    let floatingPlaceHolder2 = UILabel()
    let floatingPlaceHolder3 = UILabel()
    let floatingPlaceHolder4 = UILabel()
    let floatingPlaceHolder5 = UILabel()
    let floatingPlaceHolder6 = UILabel()
    let floatingPlaceHolder7 = UILabel()
    let floatingPlaceHolder8 = UILabel()
    let floatingPlaceHolder9 = UILabel()
    let floatingPlaceHolder10 = UILabel()
    let timePickerForDose1 = UIDatePicker()
    let timePickerForDose2 = UIDatePicker()
    let timePickerForDose3 = UIDatePicker()
    
    var pickerView1 = UIPickerView()
    var pickerView2 = UIPickerView()
    var pickerView3 = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .white
        
        self.datePickerTextField.datePicker(target: self,
                                  doneAction: #selector(doneAction),
                                  cancelAction: #selector(cancelAction),
                                            datePickerMode: .date)

        createFloatingLabel()
        
        selectMemberTextField.optionArray = ["Tony Stark","Peter Parker","Steve Rogers", "Bruce Banner"]
        selectMemberTextField.didSelect{(selectedText , index ,id) in
            self.selectMemberTextField.text = "\(selectedText)"
        }
        selectMemberTextField.arrowSize = 10
        selectMemberTextField.arrowColor = .black
        selectMemberTextField.checkMarkEnabled = false
        selectMemberTextField.selectedRowColor = .white
        
        medicineRoutineTextField.optionArray = ["Daily", "Weekly"]
        medicineRoutineTextField.didSelect{(selectedText , index ,id) in
            self.medicineRoutineTextField.text = "\(selectedText)"
        }
        medicineRoutineTextField.arrowSize = 10
        medicineRoutineTextField.arrowColor = .black
        medicineRoutineTextField.checkMarkEnabled = false
        medicineRoutineTextField.selectedRowColor = .white
        
        remindMeTextField.optionArray = ["1 time a day", "2 times a day", "3 times a day"]
        remindMeTextField.didSelect{(selectedText , index ,id) in
            self.remindMeTextField.text = "\(selectedText)"
            if self.remindMeTextField.text == "1 time a day" {
                self.dose2BgView.isHidden = true
                self.dose3BgView.isHidden = true
                self.reminderStackViewHeightConstraint.constant = 340
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            } else if self.remindMeTextField.text == "2 times a day" {
                self.dose2BgView.isHidden = false
                self.dose3BgView.isHidden = true
                self.reminderStackViewHeightConstraint.constant = 396
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            } else {
                self.reminderStackViewHeightConstraint.constant = 450
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
                self.dose2BgView.isHidden = false
                self.dose3BgView.isHidden = false
            }
        }
        remindMeTextField.arrowSize = 10
        remindMeTextField.arrowColor = .black
        remindMeTextField.checkMarkEnabled = false
        remindMeTextField.selectedRowColor = .white
        
        if let myImage = UIImage(named: "timer"){
            dose1TextField.withImage(image: myImage)
            dose2TextField.withImage(image: myImage)
            dose3TextField.withImage(image: myImage)
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
            
            print(datePickerView.date)
            print(dateString)
            
            self.datePickerTextField.resignFirstResponder()
        }
    }
    
    func createDatePicker(textField: UITextField, timePicker: UIDatePicker) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        if textField.largeContentTitle! == "Dose 1 at" {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed1))
            toolbar.setItems([doneBtn], animated: true)
            textField.inputView = timePickerForDose1
        } else if textField.largeContentTitle! == "Dose 2 at" {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
            toolbar.setItems([doneBtn], animated: true)
            textField.inputView = timePickerForDose2
        } else if textField.largeContentTitle! == "Dose 3 at" {
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed3))
            toolbar.setItems([doneBtn], animated: true)
            textField.inputView = timePickerForDose3
        }
        textField.inputAccessoryView = toolbar
        timePicker.datePickerMode = .countDownTimer
    }
    
    @objc func donePressed1(sender: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePickerForDose1.date).lowercased()
        self.dose1TextField.text = dateString
        self.view.endEditing(true)
    }
    
    @objc func donePressed2(sender: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePickerForDose2.date).lowercased()
        self.dose2TextField.text = dateString
        self.view.endEditing(true)
    }
    
    @objc func donePressed3(sender: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mma"
        let dateString = formatter.string(from: timePickerForDose3.date).lowercased()
        self.dose3TextField.text = dateString
        self.view.endEditing(true)
    }
    
    func createFloatingLabel() {
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder1, textField: selectMemberTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder2, textField: medicineNameTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder3, textField: diagnosisTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder4, textField: pillCountTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder5, textField: datePickerTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder6, textField: medicineRoutineTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder7, textField: remindMeTextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder8, textField: dose1TextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder9, textField: dose2TextField)
        
        customizeFloatingLabel(floatingPlaceHolder: floatingPlaceHolder10, textField: dose3TextField)
    }
    
    func customizeFloatingLabel(floatingPlaceHolder: UILabel, textField: UITextField) {
        floatingPlaceHolder.frame = CGRect(x: 16, y: 9, width: 500, height: 20)
        floatingPlaceHolder.font = UIFont.systemFont(ofSize: 12)
        floatingPlaceHolder.textColor = UIColor(named: "floatingLabel")
        textField.addSubview(floatingPlaceHolder)
    }
}

extension AddRemainderViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
        if textField == self.selectMemberTextField
        {
            let text = (selectMemberTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                floatingPlaceHolder1.isHidden = false
                floatingPlaceHolder1.text = selectMemberTextField.placeholder
            } else {
                floatingPlaceHolder1.isHidden = true
                self.selectMemberTextField.placeholder = "Select Member"
            }
        } else if textField == self.medicineNameTextField {
            let text = (medicineNameTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                floatingPlaceHolder2.isHidden = false
                floatingPlaceHolder2.text = medicineNameTextField.placeholder
            } else {
                floatingPlaceHolder2.isHidden = true
                self.medicineNameTextField.placeholder = "Medicine Name"
            }
        } else if textField == self.diagnosisTextField {
            let text = (diagnosisTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                floatingPlaceHolder3.isHidden = false
                floatingPlaceHolder3.text = diagnosisTextField.placeholder
            } else {
                floatingPlaceHolder3.isHidden = true
                self.diagnosisTextField.placeholder = "Diagnosis"
            }
        } else if textField == self.pillCountTextField {
            let text = (pillCountTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                floatingPlaceHolder4.isHidden = false
                floatingPlaceHolder4.text = pillCountTextField.placeholder
            } else {
                floatingPlaceHolder4.isHidden = true
                self.pillCountTextField.placeholder = "No of Pills/ Units"
            }
        } else if textField == self.datePickerTextField {
            let text = (datePickerTextField.text! as NSString).replacingCharacters(in: range, with: string)
            if !text.isEmpty{
                floatingPlaceHolder5.isHidden = false
                floatingPlaceHolder5.text = datePickerTextField.placeholder
            }
            else {
                floatingPlaceHolder5.isHidden = true
                self.datePickerTextField.placeholder = "Start Date"
            }
        }
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.selectMemberTextField {
            selectMemberTextField.showList()
            floatingPlaceHolder1.isHidden = false
            floatingPlaceHolder1.text = self.selectMemberTextField.placeholder
        } else if textField == self.datePickerTextField {
            floatingPlaceHolder5.isHidden = false
            floatingPlaceHolder5.text = datePickerTextField.placeholder
        } else if textField == self.medicineRoutineTextField {
            medicineRoutineTextField.showList()
            floatingPlaceHolder6.isHidden = false
            floatingPlaceHolder6.text = medicineRoutineTextField.placeholder
        } else if textField == self.remindMeTextField {
            remindMeTextField.showList()
            floatingPlaceHolder7.isHidden = false
            floatingPlaceHolder7.text = remindMeTextField.placeholder
        } else if textField == self.dose1TextField {
            createDatePicker(textField: dose1TextField, timePicker: timePickerForDose1)
            floatingPlaceHolder8.isHidden = false
            floatingPlaceHolder8.text = dose1TextField.placeholder
        } else if textField == self.dose2TextField {
            createDatePicker(textField: dose2TextField, timePicker: timePickerForDose2)
            floatingPlaceHolder9.isHidden = false
            floatingPlaceHolder9.text = dose2TextField.placeholder
        } else if textField == self.dose3TextField {
            createDatePicker(textField: dose3TextField, timePicker: timePickerForDose3)
            floatingPlaceHolder10.isHidden = false
            floatingPlaceHolder10.text = dose3TextField.placeholder
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
