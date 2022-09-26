//
//  EditVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import SwiftLoader

class EditVC: BaseVC {

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var effectView:EffectView?
    @IBOutlet weak var effectsCategoriesView: UIView!
    @IBOutlet weak var effectsCollectionView: UICollectionView?
    @IBOutlet weak var colorsCollectionView: UICollectionView?

    var semanticImage = SemanticImage()
    var effects:[Effect] = []
    var colors:[ColorEffect] = []
    var selectedColorIndex = 0
    var selecteEffectIndex = 0
    var isColorModuleVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        setupView()
        loadEffectsData()
    }
    
    func setupView() {
        self.effectView?.bgImageView?.image =  UIImage(named: "placeholder")
        effectsCategoriesView.backgroundColor = .clear
        colorsCollectionView?.backgroundColor = .clear
        effectsCollectionView?.backgroundColor = .clear
    }
    
    func registerCollectionCell() {
        self.effectsCollectionView?.register(EffectViewCell.getNib(), forCellWithReuseIdentifier: EffectViewCell.reuseIdentifier)
        
        self.colorsCollectionView?.register(ColorViewCell.getNib(),forCellWithReuseIdentifier: ColorViewCell.reuseIdentifier)
    }
    
    func loadEffectsData() {
        do {
            if let data = try? EffectsArray.readLocalJSONFile(forName: "FullChangeover") {
                if let effectsArray = EffectsArray.parse(jsonData: data as! Data) {
                  //You can read sampleRecordObj just like below.
                  print("effect list: \(effectsArray.effects)")
                }
            }
        } catch {
            print("error: \(error)")
        }
        
    }
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        
        
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Call First Style of effect
//        self.selectItemAt(indexPath: IndexPath(row: 0, section: 0))
    }
}


extension EditVC:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
        if effectsCollectionView == collectionView {
            return self.effects.count
        }
        else {
           return self.colors.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if effectsCollectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectViewCell.reuseIdentifier, for: indexPath) as! EffectViewCell
//            let effectBackground = self.effects[indexPath.row]
//            cell.imageView.image = UIImage(named: effectBackground.iconImage)
            cell.setupUI(isSelected: indexPath.row == self.selecteEffectIndex)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.reuseIdentifier, for: indexPath) as! ColorViewCell
//            let effectBackground = self.colors[indexPath.row]
//            cell.imageView.image = UIImage(named: effectBackground.iconImage)
            cell.setupUI(isSelected: indexPath.row == self.selectedColorIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if effectsCollectionView == collectionView {
            return CGSize(width: 80, height: 100)
        }
        else {
            return CGSize(width: 75, height: 75)
        }
    }
    
    func createRealisticCartoon(indexPath: IndexPath) {
//        SwiftLoader.show(title: "Processing please wait...", animated: true)
//        DispatchQueue.global(qos: .userInitiated).async { [self] in
//            let effectName = self.effects[indexPath.row].name
//            let effectBackgroundImageName = self.effects[indexPath.row].backgroundImage
//            let effectBackImage = UIImage(named:effectBackgroundImageName)
//
//            debugPrint("faceRectangle start")
//            var faceImage:UIImage? = Router.shared.image?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
//            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//
//            debugPrint("applyPaintEffects start")
//            var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
//
//            debugPrint("saliencyBlend start")
//
//            let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
//            Router.shared.outPutImage = swappedImage
//            debugPrint("processing stop")
//
//            DispatchQueue.main.async {
//                self.effectView?.bgImageView?.image  = swappedImage
//                SwiftLoader.hide()
//                debugPrint("SwiftLoader hide")
//            }
//        }
    }
    

    func createNewProfilePic(indexPath: IndexPath) {
//        SwiftLoader.show(title: "Processing please wait...", animated: true)
//        DispatchQueue.global(qos: .userInitiated).async { [self] in
//            let effectName = self.effects[indexPath.row].name
//            let effectBackgroundImageName = self.effects[indexPath.row].backgroundImage
//            let effectBackImage = UIImage(named:effectBackgroundImageName)
//
//            let effectFrontImageName = self.effects[indexPath.row].forgroundImage
//            let effectFrontImage = UIImage(named:effectFrontImageName)
//
//            var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
//            faceImage = faceImage?.withBackground(color: UIColor.green)
//            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//            faceImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
//            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
//
//            var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceImage!)
//            swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!)
//            Router.shared.outPutImage = swappedImage
//
//            DispatchQueue.main.async {
//                self.effectView?.bgImageView?.image  = swappedImage
//                SwiftLoader.hide()
//            }
//        }
    }
    
    func createStyleTransfer(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var outPutImage:UIImage?
//            if indexPath.row == 0 {
//                outPutImage = Router.shared.image?.applyCupheadEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//            else if indexPath.row == 1 {
//                outPutImage = Router.shared.image?.applyMosicEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//            else if indexPath.row == 2 {
//                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//
//            else if indexPath.row == 3 {//StyleTransfer_la_muse
//                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//
//            else if indexPath.row == 4 {//StyleTransfer_rain_princess
//                outPutImage = Router.shared.image?.applyPrincessEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//
//            else if indexPath.row == 5 {//StyleTransfer_shipwreck
//                outPutImage = Router.shared.image?.applyShipwreckEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//
//            else if indexPath.row == 6 {//StyleTransfer_the_scream
//                outPutImage = Router.shared.image?.applyScreamEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//
//            else if indexPath.row == 7 {//StyleTransfer_udnie
//                outPutImage = Router.shared.image?.applyUdnieEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
//
//            else if indexPath.row == 8 {//StyleTransfer_wave
//                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
//            }
            Router.shared.outPutImage = outPutImage
            DispatchQueue.main.async {
                self.effectView?.bgImageView?.image  = outPutImage
                SwiftLoader.hide()
            }
        }
    }
    
    func createFunnyCaricatures(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
//            let effectName = self.effects[indexPath.row].name
//
//            let effectBackgroundImageName = self.effects[indexPath.row].backgroundImage
//            let effectBackImage = UIImage(named:effectBackgroundImageName)
//
//            var faceImage:UIImage? = semanticImage.faceWithoutShoulder(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
//            faceImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
//            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)//Middle Image
//
//            let effectFrontImageName = self.effects[indexPath.row].forgroundImage
//            let effectFrontImage = UIImage(named:effectFrontImageName)
//
////            Router.shared.outPutImage = faceImage
//            DispatchQueue.main.async {
//                effectView?.bgImageView?.image = effectBackImage
//                effectView?.profileImageView?.image = faceImage
//                effectView?.fgImageView?.image = effectFrontImage
//                SwiftLoader.hide()
//            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if effectsCollectionView == collectionView {
            self.selecteEffectIndex = indexPath.row
            self.effectsCollectionView?.reloadData()
            
//            let effectBackground = self.effects[indexPath.row]
//            self.selectItemAt(indexPath: indexPath)
        }
        else {
            self.selectedColorIndex = indexPath.row
            self.colorsCollectionView?.reloadData()
            
//            let effectBackground = self.colors[indexPath.row]
//            self.selectItemAt(indexPath: indexPath)
        }
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

extension EditVC {

    @IBAction func shareAction(_ sender: UIButton) {
        guard (Router.shared.outPutImage != nil) else {
            return
        }
        // set up activity view controller
        let imageToShare = [ self.effectView?.bgImageView?.image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    func initializeEffect() {
        self.effects = []
        effectView?.isUserInteractionEnabled = false
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
            effectView?.isUserInteractionEnabled = true
            self.initializeFunnyCaricaturesBackgrounds()
        }
    }
    
    func initializeRealisticCartoonBackgrounds(){
//        var effectBackground = Effect(iconImage: "Style1_s1_icon", backgroundImage: "Style1_s1_back", forgroundImage: "", blendHashKey: String.empty, name: "Style1_s1")
//        effects.append(effectBackground)
    }
    
    func initializeProfilePicBackgrounds(){
//        var effectBackground = Effect(iconImage: "Style2_s1_icon", backgroundImage: "Style2_s1_back", forgroundImage: "Style2_s1_front", blendHashKey: String.empty, name: "Style2_s1")
//        effects.append(effectBackground)
    }
    
    func initializeStyleTransferBackgrounds(){
//        var effectBackground = Effect(iconImage: "StyleTransfer_Cuphead", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Cuphead")
//        effects.append(effectBackground)
//
//        effectBackground = Effect(iconImage: "StyleTransfer_Mosaic", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Mosaic")
//        effects.append(effectBackground)
//
//
//        effectBackground = Effect(iconImage: "StyleTransfer_Night", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Night")
//        effects.append(effectBackground)
//
//
//        ///
//        effectBackground = Effect(iconImage: "StyleTransfer_la_muse", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "La Muse")
//        effects.append(effectBackground)
//
//
//        effectBackground = Effect(iconImage: "StyleTransfer_rain_princess", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Rain Princess")
//        effects.append(effectBackground)
//
//
//        effectBackground = Effect(iconImage: "StyleTransfer_shipwreck", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Shipwreck")
//        effects.append(effectBackground)
//
//
//        effectBackground = Effect(iconImage: "StyleTransfer_the_scream", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Scream")
//        effects.append(effectBackground)
//
//
//        effectBackground = Effect(iconImage: "StyleTransfer_udnie", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Udnie")
//        effects.append(effectBackground)
//
//
//        effectBackground = Effect(iconImage: "StyleTransfer_wave", backgroundImage: "", forgroundImage: "", blendHashKey: String.empty, name: "Wave")
//        effects.append(effectBackground)
    }
    
    func initializeFunnyCaricaturesBackgrounds(){
//        var effectBackground = Effect(iconImage: "Style3_s1_icon", backgroundImage: "Style3_s1_back", forgroundImage: "Style3_s1_front", blendHashKey: String.empty, name: "Style3_s1")
//        effects.append(effectBackground)
    }
}
