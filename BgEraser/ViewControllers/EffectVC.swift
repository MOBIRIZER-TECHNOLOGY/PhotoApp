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
        let effectName = self.effectBackgrounds[indexPath.row].name
        let effectBackgroundImageName = self.effectBackgrounds[indexPath.row].backgroundImage
        let effectBackImage = UIImage(named:effectBackgroundImageName)
        var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
        faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
        var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
        faceCartoonImage = faceCartoonImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//        var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceCartoonImage!)
        let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
        self.imageView?.image = swappedImage
        Router.shared.outPutImage = swappedImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SwiftLoader.hide()
        }
    }
    

    func createNewProfilePic(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
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
        self.imageView?.image = swappedImage
        Router.shared.outPutImage = swappedImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SwiftLoader.hide()
        }
    }
    
    func createStyleTransfer(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
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
        Router.shared.outPutImage = outPutImage
        self.imageView?.image = outPutImage
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            SwiftLoader.hide()
        }
    }
    
    func createFunnyCaricatures(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        let effectName = self.effectBackgrounds[indexPath.row].name
        let effectBackgroundImageName = self.effectBackgrounds[indexPath.row].backgroundImage
        let effectBackImage = UIImage(named:effectBackgroundImageName)
        let faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
        let faceCartoonImage = faceImage?.applyCartoonEffects(returnResult: RemoveBackroundResult.finalImage)
        let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
//        self.imageView?.image = swappedImage
//        Router.shared.outPutImage = swappedImage
        
        let effectFrontImageName = self.effectBackgrounds[indexPath.row].forgroundImage
        let effectFrontImage = UIImage(named:effectFrontImageName)
        let finalImage = semanticImage.saliencyBlend(objectUIImage:effectFrontImage!, backgroundUIImage: swappedImage!)
        self.imageView?.image = finalImage
        Router.shared.outPutImage = finalImage

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            SwiftLoader.hide()
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



















//
//
//class EffectVC: BaseVC {
//    
//    @IBOutlet weak var sideMenuBtn: UIButton!
//    @IBOutlet weak var shareBtn: UIButton!
//    @IBOutlet weak var imageView: UIImageView?
//
//    @IBOutlet weak var cityCollectionView: UICollectionView?
//    let semanticImage = SemanticImage()
//    public var image: UIImage? =  nil
//
//    var cities : [City] = [
//                                    City(image: "Style1_s1_icon", name: "Style1_s1"),
//                                    City(image: "Style1_s2_icon", name: "Style1_s2"),
//                                    City(image: "Style1_s3_icon", name: "Style1_s3"),
//                                    City(image: "Style1_s4_icon", name: "Style1_s4"),
//                                    City(image: "Style1_s5_icon", name: "Style1_s5"),
//                                    City(image: "Style1_s6_icon", name: "Style1_s6"),
//                                    City(image: "Style2_s1_icon", name: "Style2_s1"),
//                                    City(image: "Style2_s2_icon", name: "Style2_s2"),
//                                    City(image: "Style2_s3_icon", name: "Style2_s3"),
//                                    City(image: "Style2_s4_icon", name: "Style2_s4"),
//                                    City(image: "Style2_s5_icon", name: "Style2_s5"),
//                                    City(image: "Style2_s6_icon", name: "Style2_s6")
//    ]
//                                    
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.sideMenuBtn.setTitle(String.empty, for: .normal)
//        self.shareBtn.setTitle("", for: .normal)
//        self.imageView?.image =  UIImage(named: "placeholder")
//    }
//    
//    @IBAction func selectPhotoAction(_ sender: UIButton) {
//        // Here we configure the picker to only show videos, no photos.
//        var config = YPImagePickerConfiguration()
//        config.screens = [.library, .photo]
//        config.library.mediaType = .photo
//        let picker = YPImagePicker(configuration: config)
//        picker.didFinishPicking { [unowned picker] items, _ in
//            if let photo = items.singlePhoto {
//                self.imageView?.image = photo.image
//                self.image = photo.image
//     
//            }
//            picker.dismiss(animated: true, completion: nil)
//        }
//        present(picker, animated: true, completion: nil)
//    }
//  
//    @IBAction func shareAction(_ sender: UIButton) {
//        guard (self.image != nil) else {
//            return
//        }
//        
//        // set up activity view controller
//        let imageToShare = [ self.imageView?.image]
//        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
//        activityViewController.popoverPresentationController?.sourceView = self.view
//        
//        // exclude some activity types from the list (optional)
//        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
//        
//        // present the view controller
//        self.present(activityViewController, animated: true, completion: nil)
//    }
//    
//    @IBAction func editAction(_ sender: UIButton) {
//        guard (self.image != nil) else {
//            return
//        }
//        
//        ZLImageEditorConfiguration.default()
//            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
//            .adjustTools([.brightness, .contrast, .saturation])
//
//        ZLEditImageViewController.showEditImageVC(parentVC: self, image:self.imageView?.image ?? UIImage(), editModel: nil) { [weak self] (resImage, editModel) in
//            // your code
//            self?.imageView?.image = resImage
//            self?.image = resImage
//            
//        }
//    }
//}
//
//
//extension EffectVC:  UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return cities.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! EffectsCollectionViewCell
//    
//        // Configure the cell
//        
//        let city = cities[indexPath.row]
////        cell.cityImageView.image = UIImage(named: city.image)
////        cell.cityNameLabel.text = city.name
//    
//        return cell
//    }
//    
//    func createEffect1(indexPath: IndexPath) {
//        let userImage:UIImage = UIImage(named: "demo_5")!
//        print("createEffect1.........")
//        SwiftLoader.show(title: "Processing please wait...", animated: true)
//        let effectName = cities[indexPath.row].name
//        let effectNameBG = effectName + "_back" //"e1" //
//        let effectBackImage = UIImage(named:effectNameBG)
//        
//        let faceImage:UIImage? = semanticImage.faceRectangle(uiImage: userImage)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
//        
////        var faceImageWithoutBackgroundImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//        let faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
//        
//        var faceeffectWithoutBackgroundImage = faceCartoonImage!.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//
//        
//        let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
////        let swappedImage:UIImage? =  UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceeffectWithoutBackgroundImage!)
//        
////        let swappedImage:UIImage? =  UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceCartoonImage!)
//
//        
////        let swappedImage:UIImage? = semanticImage.saliencyMask(uiImage: userImage)
//
////        let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
//
////        let img:UIImage = UIImage(named: "demo_12")!
//////        let faceCartoonImage = img.applyMosicEffects(returnResult: RemoveBackroundResult.finalImage)
////        var faceeffectWithoutBackgroundImage = img.removeBackground(returnResult: RemoveBackroundResult.finalImage)
////        faceeffectWithoutBackgroundImage =  faceeffectWithoutBackgroundImage?.withBackground(color: UIColor.green)
//////        print("swappedImage size",swappedImage!.size)
//        self.imageView?.image = swappedImage
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            SwiftLoader.hide()
//        }
//    }
//
//    func createEffect2(indexPath: IndexPath) {
//        let userImage:UIImage = UIImage(named: "demo_2")!
//        print("userImage size",userImage.size)//    userImage size (768.0, 1024.0)
//        print("createEffect2.........")
//        SwiftLoader.show(title: "Processing please wait...", animated: true)
//        let effectName = cities[indexPath.row].name
//        let effectNameBG = effectName + "_back"
//        let effectNameFront = effectName + "_front"
//        
//        
//        let effectBackImage = UIImage(named:effectNameBG)
//        let effectFrontImage = UIImage(named:effectNameFront)
//        
//        let faceImage:UIImage? = semanticImage.faceRectangle(uiImage:userImage)//?.resized(to: CGSize(width: 1200, height:1200 ))
//
//        let faceEffectImage = faceImage?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
//       
////        var faceeffectWithoutBackgroundImage = faceEffectImage!.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//
//        
//        let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceEffectImage!, backgroundUIImage: effectBackImage!)
////        let swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceeffectWithoutBackgroundImage!)
//
//        print("swappedImage size",swappedImage!.size)//swappedImage size (768.0, 1024.0)
//
//        let finalImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:effectFrontImage!, backgroundUIImage: swappedImage!)
//        
////        let finalImage:UIImage? =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!)
//
//        print("finalImage size",finalImage!.size)//    userImage size (768.0, 1024.0)
//
//
//        self.imageView?.image = finalImage
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            SwiftLoader.hide()
//        }
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print("didSelectItemAt.........Start")
//        self.image = UIImage(named: "demo_2")!
//        guard (self.image != nil) else {
//            return
//        }
//        
//        if indexPath.row < 6 {
//            self.createEffect1(indexPath: indexPath)
//        }
//        else {
//            self.createEffect2(indexPath: indexPath)
//        }
//        
//        print("didSelectItemAt.........end",indexPath.row)
//        
//        return
//        //sample effects that we can use in future
//        let iCount = indexPath.row
//        
//        if iCount == 1 {
//            let  output = self.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//        else if iCount == 2 {
//            let  output = self.image?.applyMosicEffects(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//        else if iCount  == 3 {
//            let  output = self.image?.applyCupheadEffects(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//        else if iCount == 4 {
//            let  output = self.image?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//        else if iCount == 6 {
//            let  output = self.image?.applyCartoonEffects(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//        else if iCount == 7 {
//            let  output = self.image?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//        else {
//            let  output = self.image?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
//            SwiftLoader.hide()
//        }
//    }
//}
//
//
//struct City {
//    var image:String = ""
//    var name:String = ""
//
//    init(image: String, name: String){
//        self.image = image
//        self.name = name
//    }
//}
//
