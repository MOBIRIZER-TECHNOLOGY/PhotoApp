//
//  CollectionViewCell.swift
//  cartoon
//
//  Created by pawan kumar on 27/09/22.
//

import UIKit
import UIKit
import SwiftLoader
import Nuke
import RxSwift

extension EditVC {

    func loadEffectImages(index: Int) {
        let thumbUrl = self.items[index].icon
        let bgImageUrl = self.items[index].bg
        let fgImageUrl = self.items[index].fg
        
        debugPrint("bgImageUrl test:",bgImageUrl)
        debugPrint("fgImageUrl test:",fgImageUrl)
        SwiftLoader.hide()
        return

         SwiftLoader.show(title: "Processing please wait...", animated: true)
        if fgImageUrl != nil && fgImageUrl != String.empty  && (fgImageUrl?.count ?? 0) > 5 {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            var fgUrl = URL(string: NetworkConstants.baseS3Url + (fgImageUrl ?? String.empty) )!
            var bgImageRequest = ImagePipeline.shared.rx.loadImage(with: bgUrl).asObservable()
            var fgImageRequest = ImagePipeline.shared.rx.loadImage(with: fgUrl).asObservable()
            Observable.combineLatest(bgImageRequest,fgImageRequest)
                .subscribe(onNext: { bgImageResponse,fgImageResponse in
                   
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.createRealisticCartoon(index: index,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.createNewProfilePic(index: index,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .styleTransfer {
                        self.createStyleTransfer(index: index)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        self.createFunnyCaricatures(index: index,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    
            }).disposed(by: disposeBag)
        }
        else {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            ImagePipeline.shared.rx.loadImage(with: bgUrl)
                .subscribe(onSuccess: {
                    var effectBackImage = $0.image
                   
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.createRealisticCartoon(index: index ,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.createNewProfilePic(index: index,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .styleTransfer {
                        self.createStyleTransfer(index: index)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        self.createFunnyCaricatures(index: index,effectBackImage:effectBackImage,effectFrontImage: nil)
                    }
                    
                },onFailure: { [self] error in
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        showImageLoadingErrorAlert()
                    }
            }).disposed(by: disposeBag)
        }
    }
    
    func createRealisticCartoon(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
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
                self.effectView?.bgImageView?.image  = swappedImage
                SwiftLoader.hide()
                debugPrint("SwiftLoader hide")
            }
        }
    }

    func createNewProfilePic(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            debugPrint("faceRectangle start")
//            var faceImage:UIImage? = Router.shared.image?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
            var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)

            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            
            debugPrint("applyPaintEffects start")
            var faceCartoonImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
            
            debugPrint("saliencyBlend start")
            
            var swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:faceCartoonImage!, backgroundUIImage: effectBackImage!)
            if effectFrontImage != nil {
                swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!)
//                swappedImage = semanticImage.saliencyBlend(objectUIImage:effectFrontImage!, backgroundUIImage: swappedImage!)
            }
            Router.shared.outPutImage = swappedImage
            debugPrint("processing stop")
            
            DispatchQueue.main.async {
                self.effectView?.bgImageView?.image  = swappedImage
                SwiftLoader.hide()
                debugPrint("SwiftLoader hide")
                self.emptyEffectImage.isHidden = true
                self.emptyEffectLabel.isHidden = true
            }
        }
    }

    
    func createNewProfilePic__(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            
            var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
            
//            faceImage = faceImage?.withBackground(color: UIColor.green)
            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            
            
            faceImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            
            var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!, withImage: faceImage!)
            if effectFrontImage != nil {
                swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!)
            }
            
            Router.shared.outPutImage = swappedImage
            DispatchQueue.main.async {
                self.effectView?.bgImageView?.image  = swappedImage
                SwiftLoader.hide()
                self.emptyEffectImage.isHidden = true
                self.emptyEffectLabel.isHidden = true
            }
        }

    }
    
    func createFunnyCaricatures(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var faceImage:UIImage? = semanticImage.faceWithoutShoulder(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200 ), scale: 1)
            faceImage = faceImage?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
            faceImage = faceImage?.removeBackground(returnResult: RemoveBackroundResult.finalImage)//Middle Image
//            Router.shared.outPutImage = faceImage
            DispatchQueue.main.async {
                effectView?.bgImageView?.image = effectBackImage
                effectView?.profileImageView?.image = faceImage
                if effectFrontImage != nil {
                    effectView?.fgImageView?.image = effectFrontImage
                }
                self.emptyEffectImage.isHidden = true
                self.emptyEffectLabel.isHidden = true
                SwiftLoader.hide()
            }
       }
    }
    
    func createStyleTransfer(index: Int) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var outPutImage:UIImage?
            if index == 0 {
                outPutImage = Router.shared.image?.applyCupheadEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            else if index == 1 {
                outPutImage = Router.shared.image?.applyMosicEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            else if index == 2 {
                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            }

            else if index == 3 {//StyleTransfer_la_muse
                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            }

            else if index == 4 {//StyleTransfer_rain_princess
                outPutImage = Router.shared.image?.applyPrincessEffects(returnResult: RemoveBackroundResult.finalImage)
            }

            else if index == 5 {//StyleTransfer_shipwreck
                outPutImage = Router.shared.image?.applyShipwreckEffects(returnResult: RemoveBackroundResult.finalImage)
            }

            else if index == 6 {//StyleTransfer_the_scream
                outPutImage = Router.shared.image?.applyScreamEffects(returnResult: RemoveBackroundResult.finalImage)
            }

            else if index == 7 {//StyleTransfer_udnie
                outPutImage = Router.shared.image?.applyUdnieEffects(returnResult: RemoveBackroundResult.finalImage)
            }

            else if index == 8 {//StyleTransfer_wave
                outPutImage = Router.shared.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            }
            Router.shared.outPutImage = outPutImage
            DispatchQueue.main.async {
                self.emptyEffectImage.isHidden = true
                self.emptyEffectLabel.isHidden = true

                self.effectView?.bgImageView?.image  = outPutImage

                self.effectView?.bgImageView?.image  = outPutImage
                SwiftLoader.hide()
            }
        }
    }
}

extension EditVC {
    
    func initializeStyleTransferBackgrounds(){
       
        self.items.removeAll()
        
        var data = Items()
        
        data.icon = "StyleTransfer_Cuphead"
        self.items.append(data)
        
        data.icon = "StyleTransfer_Mosaic"
        self.items.append(data)
        
    
        data.icon = "StyleTransfer_Night"
        self.items.append(data)
        
    
        data.icon = "StyleTransfer_la_muse"
        self.items.append(data)
        
        
        data.icon = "StyleTransfer_rain_princess"
        self.items.append(data)
        
        
        data.icon = "StyleTransfer_shipwreck"
        self.items.append(data)
        
        
        data.icon = "StyleTransfer_the_scream"
        self.items.append(data)
        
        
        data.icon = "StyleTransfer_udnie"
        self.items.append(data)
        
        data.icon = "StyleTransfer_wave"
        self.items.append(data)
    }
    
    
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
}
