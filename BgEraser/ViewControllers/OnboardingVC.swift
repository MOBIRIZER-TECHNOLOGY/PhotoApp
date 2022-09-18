import UIKit
import SwiftUI
 
class OnboardingVC: UIViewController {
     
    let pages: [OBPage] = [
        OBPage(color: .blue, imageName: "Home_Effect_1_After", label: ("Realistic cartoon", "Cartoonize yourself with different backgrounds!")),
        OBPage(color: .red, imageName: "Home_Effect_2_After", label: ("#NewProfilePic", "Refresh your socials with one tap!")),
        OBPage(color: .yellow, imageName: "Home_Effect_3_After", label: ("Style transfer", "Recompose the content of an image in the style.")),
        OBPage(color: .pink, imageName: "Home_Effect_4_After", label: ("Funny caricatures", "Turn yourself into a funny character."))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Without default configuration
        let onboarding = UIOnboardingView(frame: .zero, pages: pages, dismiss: doneBtnClick)

        let config = OBConfiguration(isSkippable: false, buttonLabel: "Get Started!", nextButtonSFSymbol: "arrowtriangle.forward.circle.fill", previousButtonSFSymbol: "arrowtriangle.backward.circle.fill", textContentHeight: 300, textContentBackgroundColor: .yellow, textContentCornerRadius: 100, textContactCorner: .topLeft)
           
        let onboardingWithConfig = UIOnboardingView(frame: .zero, pages: pages, configuration: config, dismiss: doneBtnClick)
        // Add onboarding view to viewController
        view.addSubview(onboarding)
        // Add onboarding view constrints
        onboarding.translatesAutoresizingMaskIntoConstraints = false
        onboarding.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        onboarding.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        onboarding.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        onboarding.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        onboarding.updateConstraintsIfNeeded()
    }
    
    @IBAction func doneBtnClick() {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
              fatalError("could not get scene delegate ")
            }
        sceneDelegate.window?.rootViewController = RootViewControllerFactory().generateHomeScreen()
    }
}
