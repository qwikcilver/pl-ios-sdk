//
//  Extensions.swift
//  CamStarter
//
//  Created by Macbook on 17/03/23.
//

import Foundation
import UIKit

@available(iOS 10.0, *)
extension UIViewController {
    
    func dismissAllController(data: PLKYCResponse) {
        self.view.window!.rootViewController?.dismiss(animated: false) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                SwiftLoader.hide()
                KYCManager.mKycManager.delegate?.didReceivePliossdkResponse(data)
            }
        }
    }
}

extension UIViewController {
    var topViewController: UIViewController? {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topViewController
        }
        if let navigationController = self as? UINavigationController {
            return navigationController.visibleViewController?.topViewController
        }
        if let tabBarController = self as? UITabBarController {
            return tabBarController.selectedViewController?.topViewController
        }
        return self
    }
}

extension UIView {
    func hideContentOnScreenCapture() {
        DispatchQueue.main.async {
            let field = UITextField()
            field.tag = 1008
            field.isSecureTextEntry = true
            self.addSubview(field)
            field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
            field.layer.name = "masklayer"
            self.layer.superlayer?.addSublayer(field.layer)
            field.layer.sublayers?.first?.addSublayer(self.layer)
        }
    }
    
    func UnhideContentOnScreenCapture() {
        DispatchQueue.main.async {
            if let viewWithTag = self.viewWithTag(1008) {
                viewWithTag.removeFromSuperview()
                // viewWithTag.layer.sublayers = nil
            }else{
                print("\(SDKConstants.TAG) Couldnt find screen No!")
            }
            self.layer.sublayers?
                .filter { $0.name == "masklayer" }
                .forEach { $0.removeFromSuperlayer() }
        }
    }
}

