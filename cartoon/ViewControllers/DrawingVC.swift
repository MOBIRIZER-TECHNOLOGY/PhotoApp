//
//  DrawingVC.swift
//  cartoon
//
//  Created by pawan kumar on 04/10/22.
//

import UIKit

class DrawingVC: BaseVC {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerView: UIView!

    var semanticImage = SemanticImage()
    let progressBarsStackView: LinearProgressBar = {
        let progressBar = LinearProgressBar()
        progressBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        progressBar.progressBarColor = .systemOrange
        progressBar.progressBarWidth = 7
        progressBar.cornerRadius = 2
        return progressBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareDemoProgressBars()
        setupView()
        createEffects() 
    }
    
    func setupView() {
        self.profileImage.image = Router.shared.image
    }
    
    func prepareDemoProgressBars() {
        progressBarsStackView.translatesAutoresizingMaskIntoConstraints = false
        bannerView?.addSubview(progressBarsStackView)
        progressBarsStackView.centerYAnchor.constraint(equalTo: bannerView!.bottomAnchor, constant: -7).isActive = true
        progressBarsStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        progressBarsStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -0).isActive = true
    }
    
    func startProgressBar() {
        progressBarsStackView.startAnimating()
        progressBarsStackView.isHidden = false
    }
    
    func stopProgressBar() {
        progressBarsStackView.stopAnimating()
        progressBarsStackView.isHidden = true
    }
}

extension DrawingVC {
    func showImageLoadingErrorAlert() {
        let actionYes : [String: () -> Void] = [ "Ok" : { (
                print("tapped YES")
        ) }]
        let arrayActions = [actionYes]
        self.showCustomAlertWith(
            message: "Unable to load effects",
            descMsg: "Please select different effect",
            itemimage: nil,
            actions: arrayActions)
       }
    
    func createEffects() {
        self.startProgressBar()
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            if Router.shared.currentEffect == .realisticCartoon {
                var faceImage:UIImage? = Router.shared.image?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
                var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
                Router.shared.image = faceCartoonImage
            }
            else if Router.shared.currentEffect == .newProfilePic {
                var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
                faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
                var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
                faceCartoonImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
                Router.shared.image = faceCartoonImage
            }
            else if Router.shared.currentEffect == .funnyCaricatures {
                var faceImage:UIImage? = semanticImage.faceWithoutShoulder(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
                faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
                var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
                Router.shared.image = faceCartoonImage
            }
            DispatchQueue.main.async {
                self.stopProgressBar()
                let vc = EditVC.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}



