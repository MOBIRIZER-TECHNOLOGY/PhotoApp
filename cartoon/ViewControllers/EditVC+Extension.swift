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
//    https://toon-app-s3.s3.ap-south-1.amazonaws.com/images/RealisticCartoon/template18c/c.png
    func loadEffectImages(indexPath: IndexPath) {
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        let thumbUrl = self.effects[indexPath.row].thumbUrl
        let bgImageUrl = self.effects[indexPath.row].bgImageUrl
        let fgImageUrl = self.effects[indexPath.row].fgImageUrl
        
        debugPrint("bgImageUrl test:",bgImageUrl)
        debugPrint("fgImageUrl test:",fgImageUrl)

        if fgImageUrl != nil && fgImageUrl != String.empty  && (fgImageUrl?.count ?? 0) > 5 {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            var fgUrl = URL(string: NetworkConstants.baseS3Url + (fgImageUrl ?? String.empty) )!
            var bgImageRequest = ImagePipeline.shared.rx.loadImage(with: bgUrl).asObservable()
            var fgImageRequest = ImagePipeline.shared.rx.loadImage(with: fgUrl).asObservable()
            Observable.combineLatest(bgImageRequest,bgImageRequest)
                .subscribe(onNext: { bgImageResponse,fgImageResponse in
                   
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.createRealisticCartoon(indexPath: indexPath,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.createNewProfilePic(indexPath: indexPath,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .styleTransfer {
                        self.createStyleTransfer(indexPath: indexPath)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        self.createFunnyCaricatures(indexPath: indexPath,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    
            }).disposed(by: disposeBag)
        }
        else {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            ImagePipeline.shared.rx.loadImage(with: bgUrl)
                .subscribe(onSuccess: {
                    var effectBackImage = $0.image
                   
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.createRealisticCartoon(indexPath: indexPath,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.createNewProfilePic(indexPath: indexPath,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .styleTransfer {
                        self.createStyleTransfer(indexPath: indexPath)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        self.createFunnyCaricatures(indexPath: indexPath,effectBackImage:effectBackImage,effectFrontImage: nil)
                    }
                    
                },onFailure: { [self] error in
                    DispatchQueue.main.async {
                        SwiftLoader.hide()
                        showImageLoadingErrorAlert()
                    }
            }).disposed(by: disposeBag)
        }
    }
    
    func createRealisticCartoon(indexPath: IndexPath,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
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
    

    func createNewProfilePic(indexPath: IndexPath,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
            faceImage = faceImage?.withBackground(color: UIColor.green)
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
            }
        }

    }
    
    func createFunnyCaricatures(indexPath: IndexPath,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
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
                self.effectView?.bgImageView?.image  = outPutImage
                SwiftLoader.hide()
            }
        }
    }
}

extension EditVC {
    
    func initializeStyleTransferBackgrounds(){
       
        self.effects.removeAll()
        var data = Effect(thumbUrl: "StyleTransfer_Cuphead", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
        
        
        data = Effect(thumbUrl: "StyleTransfer_Mosaic", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
        
        
        data = Effect(thumbUrl: "StyleTransfer_Night", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
    
        data = Effect(thumbUrl: "StyleTransfer_la_muse", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
    
       
        data = Effect(thumbUrl: "StyleTransfer_rain_princess", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
    
        
         data = Effect(thumbUrl: "StyleTransfer_shipwreck", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
         self.effects.append(data)
     
        data = Effect(thumbUrl: "StyleTransfer_the_scream", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
         self.effects.append(data)
     
          
        data = Effect(thumbUrl: "StyleTransfer_udnie", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
        
    
        data = Effect(thumbUrl: "StyleTransfer_wave", bgImageUrl: String.empty, fgImageUrl: String.empty, blendHashKey: String.empty, name: String.empty)
        self.effects.append(data)
        
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
