//
//  InAppNotification.swift
//  Medicine Remainder
//
//  Created by Kaushik on 17/08/22.
//

import UIKit
enum ToastPosition {
    case top
    case bottom
}
class InAppNotification: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let orientation = UIDevice.current.orientation
    
    var position: ToastPosition = .top
    
    var timer: Timer?
    
    var centreXConstraint: NSLayoutConstraint!
    var heightConstraint: NSLayoutConstraint!
    var widthConstraint: NSLayoutConstraint!
    var showConstraint: NSLayoutConstraint?
    var hideConstraint: NSLayoutConstraint?
    
    private var width: CGFloat {
        let isLandscape = window?.windowScene?.interfaceOrientation.isLandscape ?? false
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 359
        } else {
            if UIDevice.current.orientation.isLandscape {
                return 359
            }
            return (self.window?.bounds.width ?? 300) - 20
        }
    }
    
    static var isCurrentlyPresenting: Bool {
        if let window = keyWindow() {
            return window.subviews.first(where: { $0 is InAppNotification }) != nil
        }
        return false
    }
    
    private init(with message: String, image: UIImage?, position: ToastPosition, backgroundColor: UIColor, titleColor: UIColor, font: UIFont) {
        super.init(frame: .zero)
        self.position = position
        self.alpha = 0
        self.isUserInteractionEnabled = true
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 10
        if let image = image {
            imageView.image = image
            addSubview(imageView)
            imageView.translatesAutoresizingMaskIntoConstraints = false
        }
        
        titleLabel.text = message
        titleLabel.textColor = titleColor
        titleLabel.numberOfLines = 0
        titleLabel.font = font
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        if let _ = image {
        NSLayoutConstraint.activate([
            imageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -12),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1)
        ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
                titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1)
            ])
        }
        addSwipeGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public static func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive}).compactMap({$0 as? UIWindowScene}).first?.windows.filter({$0.isKeyWindow}).first
    }
    
    private func show(decayIn: TimeInterval) {
        if let window = InAppNotification.keyWindow() {
            window.addSubview(self)
            window.autoresizesSubviews = true
            translatesAutoresizingMaskIntoConstraints = false
            centreXConstraint = centerXAnchor.constraint(equalTo: window.centerXAnchor)
            heightConstraint =  heightAnchor.constraint(greaterThanOrEqualToConstant: 64)
            widthConstraint = widthAnchor.constraint(equalToConstant: width)
            NSLayoutConstraint.activate([
                widthConstraint,
                centreXConstraint,
                heightConstraint
            ])
            
            switch position {
            case .top:
                showConstraint = topAnchor.constraint(equalTo: window.topAnchor, constant: window.safeAreaInsets.top + 8)
                showConstraint?.isActive = true
                
                hideConstraint = bottomAnchor.constraint(equalTo: window.topAnchor)
                hideConstraint?.isActive = true
                window.layoutIfNeeded()
                hideConstraint?.isActive = false
                
            case .bottom:
                var bottomPadding: CGFloat {
                    if window.safeAreaInsets.bottom == 0 {
                        return -20
                    } else {
                        return -35
                    }
                }
                showConstraint = bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: bottomPadding)
                showConstraint?.isActive = true
                
                hideConstraint = topAnchor.constraint(equalTo: window.bottomAnchor, constant: 200)
                hideConstraint?.isActive = true
                window.layoutIfNeeded()
                hideConstraint?.isActive = false
                
            }
            UIView.animate(withDuration: 0.5) {
                self.alpha = 1
            } completion: { status in
                window.layoutIfNeeded()
            }
            
            timer = Timer.scheduledTimer(timeInterval: decayIn, target: self, selector: #selector(fadeOutView), userInfo: nil, repeats: false)
        }
    }
    
    private func addSwipeGestures() {
        
        if position == .top {
            let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp(_:)))
            swipeUpGesture.direction = .up
            addGestureRecognizer(swipeUpGesture)
        }
        
        if position == .bottom {
            let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
            swipeDownGesture.direction = .down
            addGestureRecognizer(swipeDownGesture)
            let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(_:)))
            swipeLeftGesture.direction = .left
            addGestureRecognizer(swipeLeftGesture)
            let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(_:)))
            swipeRightGesture.direction = .right
            addGestureRecognizer(swipeRightGesture)
        }
    }
    
    @objc
    private func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.centreXConstraint.constant -= self.bounds.width
            self.window?.layoutIfNeeded()
        } completion: { status in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func swipeRight(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.centreXConstraint.constant += self.bounds.width
            self.window?.layoutIfNeeded()
        } completion: { status in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func swipeUp(_ sender: UISwipeGestureRecognizer) {
        showConstraint?.isActive = false
        hideConstraint?.isActive = true
        UIView.animate(withDuration: 0.2) {
            self.superview?.layoutIfNeeded()
        }completion: { status in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func swipeDown(_ sender: UISwipeGestureRecognizer) {
        UIView.animate(withDuration: 0.2) {
            self.showConstraint?.isActive = false
            self.hideConstraint?.isActive = true
            self.window?.layoutIfNeeded()
        } completion: { status in
            self.removeFromSuperview()
        }
    }
    
    @objc
    private func fadeOutView() {
        UIView.animate(withDuration: 1) {
            self.alpha = 0
        }completion: { status in
            self.removeFromSuperview()
        }
    }
    
    public static func show(message: String, image: UIImage?, decayIn: TimeInterval = 4, position: ToastPosition = .top, backGroundColor: UIColor = .black, titleColor: UIColor = .white, font: UIFont = UIFont.systemFont(ofSize: 15, weight: .semibold)) {
        InAppNotification(with: message, image: image, position: position, backgroundColor: backGroundColor, titleColor: titleColor, font: font).show(decayIn: decayIn)
    }
}
