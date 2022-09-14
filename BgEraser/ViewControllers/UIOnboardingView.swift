import UIKit
import Onboarder
import SwiftUI

class OnboardingVC: UIViewController {
    let pages: [OBPage] = [
        OBPage(color: .blue, imageName: "img", label: ("Page 1", "First page")),
        OBPage(color: .red, imageName: "img", label: ("Page 2", "Second page"))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Without default configuration
        let onboarding = UIOnboardingView(frame: .zero, pages: pages, dismiss: doneBtnClick)

        // With custom configuration
        let config = OBConfiguration(isSkippable: false)
        let onboardingWithConfig = UIOnboardingView(frame: .zero, pages: pages, configuration: config, dismiss: doneBtnClick)
        
        // Add onboarding view to viewController
        view.addSubview(onboarding)
        // Add onboarding view constrints
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        onboarding.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        onboarding.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        onboarding.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        onboarding.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @IBAction func doneBtnClick() {
        
    }
}
