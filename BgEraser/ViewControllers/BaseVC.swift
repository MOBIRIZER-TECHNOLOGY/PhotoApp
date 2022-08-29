//
//  BaseVC.swift
//  BgEraser
//
//  Created by pawan kumar on 27/08/22.
//

import Foundation
import UIKit

open class BaseVC: UIViewController {
    
    override open func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.leftBarButtonItem?.tintColor = .gray
//        view.backgroundColor = UIColor.init(hexString: ColorConstants.disableBackgroundColor)
//        view.backgroundColor = UIColor.white

        //    applySimpleStyleNavigation(withTitle: LocalizationConstants.pageTitle.localized)
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
    public func applySimpleStyleNavigation(withTitle title: String) {
    
        
    }
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

//    /// Customize NavigationController of a ViewController
//    /// - Parameter navigationViewModel: custom appearance and  property
//    public func setUpNavigationView(withNavigationViewModel navigationViewModel: inout DBXPUINavigationModel) {
//        navigationItem.setHidesBackButton(true, animated: false)
//        if let navigationTitle = navigationViewModel.navigationTitle {
//            let lblNavTitle = UILabel()
//            lblNavTitle.textAlignment = navigationViewModel.alignment
//            lblNavTitle.font = navigationViewModel.navigationTitleFont
//            lblNavTitle.textColor = navigationViewModel.navigationTitleColor
//            lblNavTitle.text = navigationTitle
//            if navigationViewModel.alignment == .left {
//                navigationViewModel.leftBarItems?.append(UIBarButtonItem(customView: lblNavTitle))
//            } else if navigationViewModel.alignment == .right {
//                navigationViewModel.rightBarItems?.append(UIBarButtonItem(customView: lblNavTitle))
//            } else {
//                navigationItem.titleView = lblNavTitle
//            }
//        }
//        if let titleView = navigationViewModel.titleView {
//            navigationItem.titleView = titleView
//        }
//        navigationItem.leftBarButtonItems = navigationViewModel.leftBarItems
//        navigationItem.rightBarButtonItems = navigationViewModel.rightBarItems
//        navigationController?.navigationBar.barTintColor = navigationViewModel.navigationBgColor
//        navigationController?.navigationBar.shadowImage = UIImage.from(color: navigationViewModel.navigationBgColor)
//        let sharedApplication = UIApplication.shared
//        if #available(iOS 13.0, *) {
//            // swiftlint:disable:next force_unwrapping
//            let statusBar = UIView(frame: (sharedApplication.delegate?.window??.windowScene?.statusBarManager?.statusBarFrame)!)
//            statusBar.backgroundColor = navigationViewModel.navigationBgColor
//            sharedApplication.delegate?.window??.addSubview(statusBar)
//        } else {
//            sharedApplication.statusBarView?.backgroundColor = navigationViewModel.navigationBgColor
//        }
//    }
}

//
//extension UIViewController {
//    private var backIcon: UIImage {
//        DBXPUIIconHelper.iconFor(.backIcon, ColorUtils.sharedInstance().theme.primaryColor.getUIColor())
//    }
//    /// Created easy to access back button
//    public var backBarButtonItem: UIBarButtonItem {
//        UIBarButtonItem(image: view.isRTL() ? backIcon.withHorizontallyFlippedOrientation(): backIcon,
//                        style: .plain, target: self, action: #selector(dbxpUIBackAction))
//    }
//
//    /// Customize NavigationController of a ViewController
//    @objc
//    open func dbxpUIBackAction() {
//        navigationController?.popViewController(animated: true)
//    }
//
//
//
//    /// Commonly used style for DBXP with backbutton arrow and left aligned title label
//    /// - Parameter title: Title text
//    public func applySimpleStyleNavigation(withTitle title: String) {
//        var navigationInfo = DBXPUINavigationModel()
//        let backButton = backBarButtonItem
//        backButton.accessibilityIdentifier = Constants.dbxpUIBackButtonId
//        navigationInfo.leftBarItems = [backButton]
//        navigationInfo.navigationTitle = title
//        setUpNavigationView(withNavigationViewModel: &navigationInfo)
//    }
//
//}
