//
//  ImageSelectorVC.swift
//  BgEraser
//
//  Created by pawan kumar on 26/08/22.
//

import Foundation
import UIKit
import SwiftLoader

class ImageSelectorVC: BaseVC {

    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var sideMenuBtn: UIButton!

    var semanticImage = SemanticImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView?.image = Router.shared.image
        self.sideMenuBtn.setTitle(String.empty, for: .normal)
//        createNewProfilePic()
    }

    
    func createNewProfilePic() {
        let effectBackgroundImageName = "Style2_s5_back"
        let effectBackImage = UIImage(named:effectBackgroundImageName)
        var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
        faceImage = faceImage?.withBackground(color: UIColor.green)
        faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
        faceImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
        faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
        let effectFrontImageName = "Style2_s5_front"
        let effectFrontImage = UIImage(named:effectFrontImageName)
        var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceImage!)
        swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!)
        self.imageView?.image = swappedImage
    }
    
    
    @IBAction func createEffecAction(_ sender: UIButton) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        if Router.shared.currentEffect == .styleTransfer {
            //Face image not required for this effect
        }
        else {
//            let faceImage:UIImage? = Router.shared.semanticImage?.faceRectangle(uiImage: Router.shared.image ?? UIImage())?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
//            Router.shared.faceimage = faceImage
        }
        
        
        
//        let faceImage:UIImage? = Router.shared.semanticImage?.faceRectangle(uiImage: Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
//        Router.shared.faceimage = faceImage

        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            SwiftLoader.hide()
            let vc = EffectVC.instantiate()
            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}
 
