//
//  UserAlertViewController.swift
//  Medicine Remainder
//
//  Created by Kaushik on 18/08/22.
//

import Foundation
import UIKit

enum AlertType {
    case alert
    case toast //landscape
}

struct AlertConfig {
    let image: UIImage?
    let title: String?
    let subTitle: String?
    let placeholder: String?
    let buttonTitle: [ButtonConfig]?
    let dismissTime: Double?
    let alertType: AlertType!
    let isDismissable: Bool
    
    init(_image: UIImage? = nil, _title: String? = nil, _subTitle: String? = nil,_placeholder: String? = nil ,_isDismissable: Bool = false, _buttons: [ButtonConfig]? = nil, _dismissTime: Double? = nil, _alertType: AlertType) {
        image = _image
        title = _title
        subTitle = _subTitle
        placeholder = _placeholder
        buttonTitle = _buttons
        dismissTime = _dismissTime
        alertType = _alertType
        isDismissable = _isDismissable
    }
}

struct ButtonConfig {
    let title: String?
    let titleColor: UIColor?
    let buttonState: Bool?
    
    init(_title: String? = nil, _titleColor: UIColor? = nil, _buttonState: Bool? = nil) {
        title = _title
        titleColor = _titleColor
        buttonState = _buttonState
    }
}

class UserAlertsViewController: UIViewController {
    
    var config: AlertConfig!
    var titleLabel = UILabel()
    var subTitleLabel = UILabel()
    var imageView = UIImageView()
    var actionButton = UIButton()
    var actionButton1 = UIButton()
    var completion: ((Int) -> Void)?
    
    static func show(config: AlertConfig, on: UIViewController, completion: ((Int) -> Void)? = nil) {
        let controller = UserAlertsViewController()
        var dismissAfter: Double = 100000000000
        
        controller.config = config
        if let _time = config.dismissTime {
            dismissAfter = _time
        }
        controller.modalPresentationStyle = .overFullScreen
        if config.alertType == .alert {
            controller.modalTransitionStyle = .crossDissolve
        }
        controller.completion = completion
        if let topController = self.topViewController() as? UserAlertsViewController {
            if topController.config.isDismissable && config.alertType == .alert {
                let presentingVC = on.presentingViewController
                topController.dismiss(animated: true, completion: {
                    if let presentingVC = presentingVC {
                        self.present(controller, on: presentingVC, dismissAfter: dismissAfter)
                    }
                })
            }
        } else {
            self.present(controller, on: on, dismissAfter: dismissAfter)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if config.alertType == .toast {
            configureToastView()
        } else {
            configureAlertView()
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        }
    }
    
    static private func present(_ controller: UserAlertsViewController, on: UIViewController, dismissAfter: Double) {
        on.present(controller, animated: true) {
            let topController = self.topViewController()
            DispatchQueue.main.asyncAfter(deadline: .now() + dismissAfter) {
                if let useralertVC = topController as? UserAlertsViewController {
                    useralertVC.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    func configureAlertView() {
        var alertWidth: CGFloat
        if UIDevice.current.userInterfaceIdiom == .pad {
            if view.bounds.width < view.bounds.height {
                alertWidth = view.bounds.width / 2
            } else {
                alertWidth = view.bounds.width / 3
            }
        } else {
            if view.bounds.width < view.bounds.height {
                alertWidth = view.bounds.width - 32
            } else {
                alertWidth = 343
            }
        }
        let alertView = UIView(frame: CGRect(x: 0, y: 0, width: alertWidth, height: 290))
        view.addSubview(alertView)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        alertView.widthAnchor.constraint(equalToConstant: alertWidth).isActive = true
        alertView.heightAnchor.constraint(lessThanOrEqualToConstant: 315).isActive = true
        alertView.backgroundColor = UIColor(named: "dialogBoxBg")
        alertView.layer.cornerRadius = 16.0
        
        var contentView = UIStackView()
        if let title = config.title {
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.textAlignment = .center
            titleLabel.font =  UIFont.systemFont(ofSize: 20, weight: .semibold)
            titleLabel.textColor = UIColor(named: "labelBlack")
        }
        
        if let subTitle = config.subTitle {
            subTitleLabel.text = subTitle
            subTitleLabel.numberOfLines = 0
            subTitleLabel.textAlignment = .center
            subTitleLabel.font =  UIFont.systemFont(ofSize: 17, weight: .regular)
            subTitleLabel.textColor = UIColor(named: "labelBlack")
        }
        
        if let _ = config.image {
            imageView.image = config.image
            imageView.contentMode = .scaleAspectFit
            contentView = UIStackView(arrangedSubviews: [imageView, titleLabel, subTitleLabel])
        } else {
            contentView = UIStackView(arrangedSubviews: [titleLabel, subTitleLabel])
        }
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.axis = .vertical
        contentView.spacing = 8
        
        alertView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        contentView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        contentView.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 16).isActive = true
        
        if let buttonTitles = config.buttonTitle {
            let divider = UILabel()
            divider.backgroundColor = UIColor(named: "dividerColor")
            alertView.addSubview(divider)
            divider.translatesAutoresizingMaskIntoConstraints = false
            divider.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0).isActive = true
            divider.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0).isActive = true
            divider.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20).isActive = true
            divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            if buttonTitles.count == 2, let buttonTitle1 = buttonTitles[0].title, let buttonTitle2 = buttonTitles[1].title, let buttonColor1 = buttonTitles[0].titleColor, let buttonColor2 = buttonTitles[1].titleColor {
                actionButton.setTitle(buttonTitle1, for: .normal)
                actionButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17, weight: .regular)
                actionButton.setTitleColor(buttonColor1, for: .normal)
                actionButton1.setTitle(buttonTitle2, for: .normal)
                actionButton1.titleLabel?.font =  UIFont.systemFont(ofSize: 17, weight: .bold)
                actionButton1.setTitleColor(buttonColor2, for: .normal)
                
                actionButton.tag = 0
                actionButton.addTarget(self, action: #selector(viewTapAction), for: .touchUpInside)
                actionButton1.tag = 1
                actionButton1.addTarget(self, action: #selector(viewTapAction), for: .touchUpInside)
                var buttonStackView = UIStackView()
                let separator = UIView()
                separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
                separator.backgroundColor = UIColor(named: "dividerColor")
                buttonStackView = UIStackView(arrangedSubviews: [actionButton,separator, actionButton1])
                actionButton.widthAnchor.constraint(equalTo: actionButton1.widthAnchor, multiplier: 1).isActive = true
                separator.heightAnchor.constraint(equalTo: buttonStackView.heightAnchor, multiplier: 1).isActive = true
                buttonStackView.axis = .horizontal
                buttonStackView.spacing = 2
                buttonStackView.distribution = .fillProportionally
                alertView.addSubview(buttonStackView)
                buttonStackView.translatesAutoresizingMaskIntoConstraints = false
                buttonStackView.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0).isActive = true
                buttonStackView.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0).isActive = true
                buttonStackView.heightAnchor.constraint(equalToConstant: 54).isActive = true
                buttonStackView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 0).isActive = true
                buttonStackView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0).isActive = true
            }
            else if let buttonTitle = buttonTitles[0].title, let buttonColor = buttonTitles[0].titleColor {
                actionButton.setTitle(buttonTitle, for: .normal)
                actionButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17, weight: .bold)
                actionButton.setTitleColor(buttonColor, for: .normal)
                actionButton.tag = 0
                actionButton.addTarget(self, action: #selector(viewTapAction), for: .touchUpInside)
                alertView.addSubview(actionButton)
                actionButton.translatesAutoresizingMaskIntoConstraints = false
                actionButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 0).isActive = true
                actionButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: 0).isActive = true
                actionButton.heightAnchor.constraint(equalToConstant: 54).isActive = true
                actionButton.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 0).isActive = true
                actionButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: 0).isActive = true
                
                if let state = buttonTitles[0].buttonState {
                    actionButton.isEnabled = state
                }
            }
        } else {
            contentView.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -16).isActive = true
        }
    }
    
    func configureToastView() {
        let toastView = UIView(frame: CGRect(x: 0, y: 0, width: 344, height: 250))
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastView.widthAnchor.constraint(equalToConstant: 344).isActive = true
        toastView.backgroundColor = UIColor(named: "dialogBoxBg")
        toastView.layer.cornerRadius = 16.0
        
        let toastLabel = UILabel()
        toastView.addSubview(toastLabel)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.leadingAnchor.constraint(equalTo: toastView.leadingAnchor, constant: 14).isActive = true
        toastLabel.trailingAnchor.constraint(equalTo: toastView.trailingAnchor, constant: -14).isActive = true
        toastLabel.topAnchor.constraint(equalTo: toastView.topAnchor, constant: 14).isActive = true
        toastLabel.bottomAnchor.constraint(equalTo: toastView.bottomAnchor, constant: -14).isActive = true
        toastLabel.numberOfLines = 0
        toastLabel.font =  UIFont.systemFont(ofSize: 17, weight: .regular)
        toastLabel.textColor = UIColor(named: "labelBlack")
        toastLabel.textAlignment = .center
        toastLabel.text = config.subTitle
    }
    
    @objc func viewTapAction(sender: UIButton)  {
        self.dismiss(animated: true, completion: { [self] in
            if sender.tag == 0 {
                (completion ?? {_ in })(0)
            }
            else{
                (completion ?? {_ in })(1)
            }
        })
    }
}

extension NSObject {
    static func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller ?? UIViewController()
    }

    func topViewController() -> UIViewController {
        return type(of: self).topViewController()
    }
    
    func showMessage(_ message:String, handler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.topViewController().present(alert, animated: true, completion:nil)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: { (action) in
            handler?()
        }))
    }
    
    func showMessageWithoutAction(_ message:String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.topViewController().present(alert, animated: true, completion:nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5, execute: {
            alert.dismiss(animated: true, completion: nil)
        })
    }
    
    func showMessage(title: String? = nil, message:String? = nil, showCancel: Bool = true, actions:[UIAlertAction]) {
        guard actions.count > 0 else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle:.alert)
        self.topViewController().present(alert, animated: true, completion:nil)
        for action in actions {
            alert.addAction(action)
        }
        if showCancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
    }
    
    func showActionSheet(title: String? = nil, message:String? = nil, showCancel: Bool = true, actions:[UIAlertAction]) {
        guard actions.count > 0 else {
            return
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert)
        self.topViewController().present(alert, animated: true, completion:nil)
        for action in actions {
            alert.addAction(action)
        }
        if showCancel {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
    }
    
    class func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func appDelegate() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func formatDate(myDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd" //Your date format
        let planDate = dateFormatter.date(from: myDate)
        dateFormatter.dateFormat = "E, dd MMM"
        if planDate != nil {
            return dateFormatter.string(from:planDate!)
        }else {
            return ""
        }
    }
    
    func formatTime(myTime: String) -> String {
        let timeformatter = DateFormatter()
        timeformatter.dateFormat = "HH:mm"
        let outputTime = timeformatter.date(from: myTime)
        timeformatter.dateFormat = "hh:mm a"
        if outputTime != nil {
            return timeformatter.string(from: outputTime!)
        } else {
            return ""
        }
    }
    
    func format24Time(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func formatDOB(myDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd" //Your date format
        let planDate = dateFormatter.date(from: myDate)
        dateFormatter.dateFormat = "dd MMM yyyy"
        if planDate != nil {
            return dateFormatter.string(from:planDate!)
        }else {
            return ""
        }
    }
    
    func formatDateAndTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E MMM d, yyyy  HH:mm"
        return dateFormatter.string(from: date)
    }
    
    static func getNextDay9AM() -> Date {
        let now = Date()
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, hour: 9)  // <- 17:00 = 5pm
        var next9am = calendar.nextDate(after: now, matching: components, matchingPolicy: .nextTime)!
        if calendar.isDateInToday(next9am) {
            next9am = calendar.nextDate(after: next9am, matching: components, matchingPolicy: .nextTime)!
        }
        let diff = calendar.dateComponents([.second], from: now, to: next9am)
        return Date().addingTimeInterval(TimeInterval(diff.second!+1))
    }
}
