//
//  BaseVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import Foundation
import UIKit

open class BaseVC: UIViewController {
    
    var settingPopViewController: SettingsVC? = nil
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.yellow
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
    }

    @IBAction func closeButtonTapped(_: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func backButtonTapped(_: Any) {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        }
    }

    /// Commonly used style for DBXP with backbutton arrow and left aligned title label
    /// - Parameter title: Title text
    public func applySimpleStyleNavigation(withTitle title: String) {}
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.view.backgroundColor = .black

        alert.view.alpha = 0.5

        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    
    func settingPopOver(_ viewController: UIViewController) {
        self.settingPopViewController = SettingsVC.instantiate()
        //self.settingPopViewController?.showInView(viewController.view, animated: true)
        //self.settingPopViewController?.delegate = self
        self.settingPopViewController?.showInView(viewController.view, animated: true, { selectedOption in
            print("Setting selected option: \(selectedOption.getSettingOptionsString())")
        })
    }
}

