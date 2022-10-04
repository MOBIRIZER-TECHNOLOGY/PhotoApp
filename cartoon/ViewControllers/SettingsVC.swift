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
            return UIImage(named: "share_icn")
        case .about:
            return UIImage(named: "about_icn")
        case .policy:
            return UIImage(named: "privacy_icn")
        case .terms:
            return UIImage(named: "terms_icn")
        case .contact:
            return UIImage(named: "contact_icn")
        case .feedback:
            return UIImage(named: "feedback_icn")
        case .rateus:
            return UIImage(named: "share_icn")
        }
    }
    
    func getSettingOptionsSelectedImages() -> UIImage? {
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
        self.popUpView.setCornerRadiusWith(radius: 10, borderWidth: 1, borderColor: UIColor.clear)
        self.tableView.reloadData()
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
        let screenHeight:  CGFloat = UIScreen.main.bounds.height
        print("screenHeight",screenHeight)
        if screenHeight < 700 {//667
            return 50.0
        }
        else {//932
            return 70.0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSettingOption = SettingOptions.allValidValues[indexPath.row]
        self.settingClosure?(selectedSettingOption)
        print("You  want to open; \(selectedSettingOption.getSettingOptionsString())")
        if let url = URL(string: "https://www.google.com") {
            UIApplication.shared.open(url)
        }
    }
    
}
