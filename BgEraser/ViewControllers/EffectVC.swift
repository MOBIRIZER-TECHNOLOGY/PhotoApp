//
//  EffectViewController.swift
//  BgEraser
//
//  Created by pawan kumar on 26/08/22.
//

import UIKit
import SwiftLoader
import ZLImageEditor
import YPImagePicker

class EffectVC: BaseVC {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var effectCollectionView: UICollectionView?
    var semanticImage = SemanticImage()

    var effectBackgrounds:[EffectBackgrounds] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeEffectBackgrounds()
        self.backButton.setTitle(String.empty, for: .normal)
        self.shareBtn.setTitle("", for: .normal)
        self.imageView?.image =  UIImage(named: "placeholder")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Call First Style of effect
        self.selectItemAt(indexPath: IndexPath(row: 0, section: 0))
    }
}


extension EffectVC:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         self.effectBackgrounds.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EffectBgCollectionViewCell", for: indexPath) as! EffectBgCollectionViewCell
        let effectBackground = self.effectBackgrounds[indexPath.row]
        cell.imageView.image = UIImage(named: effectBackground.iconImage)
        cell.titleLabel.text = effectBackground.name
        return cell
    }
    
    func createRealisticCartoon(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let effectName = self.effectBackgrounds[indexPath.row].name
            let effectBackgroundImageName = self.effectBackgrounds[indexPath.row].backgroundImage
            let effectBackImage = UIImage(named:effectBackgroundImageName)
             
            debugPrint("faceRectangle start")
            var faceImage:UIImage? = Router.shared.image?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            
            debugPrint("applyPaintEffects start")
            var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)

            debugPrint("saliencyBlend start")

            let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
            Router.shared.outPutImage = swappedImage
            debugPrint("processing stop")

            DispatchQueue.main.async {
                self.imageView?.image = swappedImage
                SwiftLoader.hide()
                debugPrint("SwiftLoader hide")

            }
        }
    }
    

    func createNewProfilePic(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let effectName = self.effectBackgrounds[indexPath.row].name
            let effectBackgroundImageName = self.effectBackgrounds[indexPath.row].backgroundImage
            let effectBackImage = UIImage(named:effectBackgroundImageName)
            
            let effectFrontImageName = self.effectBackgrounds[indexPath.row].forgroundImage
            let effectFrontImage = UIImage(named:effectFrontImageName)
            
            var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
            faceImage = faceImage?.withBackground(color: UIColor.green)
            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            faceImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            
            var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceImage!)
            swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!)
            Router.shared.outPutImage = swappedImage

            DispatchQueue.main.async {
                self.imageView?.image = swappedImage
                SwiftLoader.hide()
            }
        }
    }
    
    func createStyleTransfer(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var outPutImage:UIImage?
            if indexPath.row == 0 {
                outPutImage = Router.shared.image?.applyCupheadEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            else if indexPath.row == 1 {
                outPutImage = Router.shared.image?.applyMosicEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            else if indexPath.row == 2 {
                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            
            else if indexPath.row == 3 {//StyleTransfer_la_muse
                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            
            else if indexPath.row == 4 {//StyleTransfer_rain_princess
                outPutImage = Router.shared.image?.applyPrincessEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            
            else if indexPath.row == 5 {//StyleTransfer_shipwreck
                outPutImage = Router.shared.image?.applyShipwreckEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            
            else if indexPath.row == 6 {//StyleTransfer_the_scream
                outPutImage = Router.shared.image?.applyScreamEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            
            else if indexPath.row == 7 {//StyleTransfer_udnie
                outPutImage = Router.shared.image?.applyUdnieEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            
            else if indexPath.row == 8 {//StyleTransfer_wave
                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            Router.shared.outPutImage = outPutImage

            DispatchQueue.main.async {
                self.imageView?.image = outPutImage
                SwiftLoader.hide()
            }
        }
    }
    
    func createFunnyCaricatures(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
           
            let effectName = self.effectBackgrounds[indexPath.row].name
            let effectBackgroundImageName = self.effectBackgrounds[indexPath.row].backgroundImage
            let effectBackImage = UIImage(named:effectBackgroundImageName)
            let faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
            let faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
            let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
            //        self.imageView?.image = swappedImage
            //        Router.shared.outPutImage = swappedImage
            
            let effectFrontImageName = self.effectBackgrounds[indexPath.row].forgroundImage
            let effectFrontImage = UIImage(named:effectFrontImageName)
            let finalImage = semanticImage.saliencyBlend(objectUIImage:effectFrontImage!, backgroundUIImage: swappedImage!)
//            Router.shared.outPutImage = finalImage

            Router.shared.outPutImage = finalImage

            
            DispatchQueue.main.async {
                self.imageView?.image = finalImage
                SwiftLoader.hide()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let effectBackground = self.effectBackgrounds[indexPath.row]
        self.selectItemAt(indexPath: indexPath)
    }
    
    func selectItemAt(indexPath: IndexPath) {
        if Router.shared.currentEffect == .realisticCartoon {
            self.createRealisticCartoon(indexPath: indexPath)
        }
        else if Router.shared.currentEffect == .newProfilePic {
            self.createNewProfilePic(indexPath: indexPath)
        }
        else if Router.shared.currentEffect == .styleTransfer {
            self.createStyleTransfer(indexPath: indexPath)
        }
        else if Router.shared.currentEffect == .funnyCaricatures {
            self.createFunnyCaricatures(indexPath: indexPath)
        }
    }
}

extension EffectVC {

    @IBAction func shareAction(_ sender: UIButton) {
        guard (Router.shared.outPutImage != nil) else {
            return
        }
        // set up activity view controller
        let imageToShare = [ self.imageView?.image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        guard (Router.shared.outPutImage != nil) else {
            return
        }
        
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])

        ZLEditImageViewController.showEditImageVC(parentVC: self, image:self.imageView?.image ?? UIImage(), editModel: nil) { [weak self] (resImage, editModel) in
            // your code
            self?.imageView?.image = resImage
            Router.shared.outPutImage = resImage
        }
    }
    
    func initializeEffectBackgrounds() {
        self.effectBackgrounds = []
        if Router.shared.currentEffect == .realisticCartoon {
            self.initializeRealisticCartoonBackgrounds()
        }
        else if Router.shared.currentEffect == .newProfilePic {
            self.initializeProfilePicBackgrounds()
        }
        else if Router.shared.currentEffect == .styleTransfer {
            self.initializeStyleTransferBackgrounds()
        }
        else if Router.shared.currentEffect == .funnyCaricatures {
            self.initializeFunnyCaricaturesBackgrounds()
        }
    }
    
    func initializeRealisticCartoonBackgrounds(){
        var effectBackground = EffectBackgrounds(iconImage: "Style1_s1_icon", backgroundImage: "Style1_s1_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s1")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style1_s2_icon", backgroundImage: "Style1_s2_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s2")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "Style1_s3_icon", backgroundImage: "Style1_s3_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s3")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "Style1_s4_icon", backgroundImage: "Style1_s4_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s4")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style1_s5_icon", backgroundImage: "Style1_s5_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s5")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style1_s6_icon", backgroundImage: "Style1_s6_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s6")
        effectBackgrounds.append(effectBackground)

    }
    
    func initializeProfilePicBackgrounds(){
        var effectBackground = EffectBackgrounds(iconImage: "Style2_s1_icon", backgroundImage: "Style2_s1_back", forgroundImage: "Style2_s1_front", blendHashKey: String.empty, name: "Style2_s1")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style2_s2_icon", backgroundImage: "Style2_s2_back", forgroundImage: "Style2_s2_front", blendHashKey: String.empty, name: "Style2_s2")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "Style2_s3_icon", backgroundImage: "Style2_s3_back", forgroundImage: "Style2_s3_front", blendHashKey: String.empty, name: "Style2_s3")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "Style2_s4_icon", backgroundImage: "Style2_s4_back", forgroundImage: "Style2_s4_front", blendHashKey: String.empty, name: "Style2_s4")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style2_s5_icon", backgroundImage: "Style2_s5_back", forgroundImage: "Style2_s5_front", blendHashKey: String.empty, name: "Style2_s5")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style2_s6_icon", backgroundImage: "Style2_s6_back", forgroundImage: "Style2_s6_front", blendHashKey: String.empty, name: "Style2_s6")
        effectBackgrounds.append(effectBackground)
    }
    
    func initializeStyleTransferBackgrounds(){
        var effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_Cuphead", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Cuphead")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_Mosaic", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Mosaic")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_Night", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Night")
        effectBackgrounds.append(effectBackground)
        
        
        ///
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_la_muse", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "La Muse")
        effectBackgrounds.append(effectBackground)
  
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_rain_princess", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Rain Princess")
        effectBackgrounds.append(effectBackground)
  
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_shipwreck", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Shipwreck")
        effectBackgrounds.append(effectBackground)
  
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_the_scream", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Scream")
        effectBackgrounds.append(effectBackground)
  
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_udnie", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Udnie")
        effectBackgrounds.append(effectBackground)
  
        
        effectBackground = EffectBackgrounds(iconImage: "StyleTransfer_wave", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Wave")
        effectBackgrounds.append(effectBackground)
    }
    
    func initializeFunnyCaricaturesBackgrounds(){
        var effectBackground = EffectBackgrounds(iconImage: "Style3_s1_icon", backgroundImage: "Style3_s1_back", forgroundImage: "Style3_s1_front", blendHashKey: String.empty, name: "Style3_s1")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style3_s2_icon", backgroundImage: "Style3_s2_back", forgroundImage: "Style3_s2_front", blendHashKey: String.empty, name: "Style3_s2")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "Style3_s3_icon", backgroundImage: "Style3_s3_back", forgroundImage: "Style3_s3_front", blendHashKey: String.empty, name: "Style3_s3")
        effectBackgrounds.append(effectBackground)
        
        
        effectBackground = EffectBackgrounds(iconImage: "Style3_s4_icon", backgroundImage: "Style3_s4_back", forgroundImage: "Style3_s4_front", blendHashKey: String.empty, name: "Style3_s4")
        effectBackgrounds.append(effectBackground)
        
        effectBackground = EffectBackgrounds(iconImage: "Style3_s5_icon", backgroundImage: "Style3_s5_back", forgroundImage: "Style3_s5_front", blendHashKey: String.empty, name: "Style3_s5")
        effectBackgrounds.append(effectBackground)
    }
}
