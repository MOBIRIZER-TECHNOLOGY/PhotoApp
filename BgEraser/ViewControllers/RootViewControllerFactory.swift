//
//  RootViewControllerFactory.swift
//  BgEraser
//
//  Created by pawan kumar on 13/09/22.
//

import UIKit

class RootViewControllerFactory {

  var rootViewController: UIViewController {
    if shouldDisplayOnboardingScreen() {
      return generateOnboardingScreen()
    } else {
      return generateHomeScreen()
    }
  }

  private func shouldDisplayOnboardingScreen() -> Bool {
    // Your logic to decide whether you should display it or not.
      return false
  }

  func generateOnboardingScreen() -> UIViewController {
      OnboardingVC()
  }

  func generateHomeScreen() -> UIViewController {
      var mainView = UIStoryboard(name: "Main", bundle: nil)
      let vc : UIViewController = mainView.instantiateInitialViewController()! as UIViewController
      return vc
  }

}

