//
//  SettingsVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import QuartzCore

enum SettingOptions {
    case none
    case share
    case about
    case policy
    case terms
    case contact
    case feedback
    case rateus
    
    func getSettingOptionsString() -> String {
        switch self {
        case .none:
            return ""
        case .share:
            return "Share ToonMe"
        case .about:
            return "About Us"
        case .policy:
            return "Privacy Policy"
        case .terms:
            return "Terms of Use"
        case .contact:
            return "Contact Us"
        case .feedback:
            return "Feedback & Suggesstioons"
        case .rateus:
            return "Rate Us"
        }
    }
    
    func getSettingOptionsImages() -> UIImage? {
        switch self {
        case .none:
            return nil
        case .share:
            return UIImage(named: "share_icn1")
        case .about:
            return UIImage(named: "about_icn1")
        case .policy:
            return UIImage(named: "privacy_icn1")
        case .terms:
            return UIImage(named: "terms_icn1")
        case .contact:
            return UIImage(named: "contact_icn1")
        case .feedback:
            return UIImage(named: "feedback_icn1")
        case .rateus:
            return UIImage(named: "share_icn1")
        }
    }
    
    static let allValidValues = [ SettingOptions.share, SettingOptions.about, SettingOptions.policy, SettingOptions.terms,  SettingOptions.contact, SettingOptions.feedback, SettingOptions.rateus]
    
}


class SettingsVC: BaseVC {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var selectedSettingOption: SettingOptions = SettingOptions.none
    var settingClosure: ((_ selectedOption: SettingOptions) -> Void)?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.popUpView.layer.cornerRadius = 5
        self.popUpView.layer.shadowOpacity = 0.8
        self.popUpView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        self.tableView.reloadData()
    }
    
    open func showInView(_ aView: UIView!, animated: Bool, _ settingClosure: @escaping((_ selectedOption: SettingOptions) -> Void)) {
        self.view.frame =  CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height:  UIScreen.main.bounds.height)
        self.settingClosure = settingClosure
        
        aView.addSubview(self.view)
        if animated {
            self.showAnimate()
        }
    }
    
    func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    @IBAction open func closePopup(_ sender: AnyObject) {
        self.removeAnimate()
    }
    
    @IBAction open func goProAction(_ sender: AnyObject) {
        let proVC = GoProVC.instantiate()
        proVC.modalPresentationStyle = .fullScreen
        self.present(proVC, animated: true, completion: nil)
    }


}

extension SettingsVC:  UITableViewDelegate,  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOptions.allValidValues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = self.tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if( !(cell != nil)) {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "Cell")
        }
        let value = SettingOptions.allValidValues[indexPath.row]
        cell?.imageView?.image = value.getSettingOptionsImages()
        cell?.textLabel?.text = value.getSettingOptionsString()
        cell?.selectionStyle = .none
        return  cell ?? UITableViewCell()
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSettingOption = SettingOptions.allValidValues[indexPath.row]
        self.settingClosure?(selectedSettingOption)
        print("You  want to open; \(selectedSettingOption.getSettingOptionsString())")
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
        self.removeAnimate()
    }
    
}
