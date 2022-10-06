//
//  CollectionViewCell.swift
//  cartoon
//
//  Created by pawan kumar on 27/09/22.
//

import UIKit
import UIKit
import Nuke
import RxSwift

extension EditVC {

    func loadEffectImages(index: Int) {
        let thumbUrl = self.items[index].icon
        let bgImageUrl = self.items[index].bg
        let fgImageUrl = self.items[index].fg
        
        debugPrint("bgImageUrl test:",bgImageUrl)
        debugPrint("fgImageUrl test:",fgImageUrl)
        self.startProgressBar()
        
        if fgImageUrl != nil && fgImageUrl != String.empty  && (fgImageUrl?.count ?? 0) > 5 {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            var fgUrl = URL(string: NetworkConstants.baseS3Url + (fgImageUrl ?? String.empty) )!
            var bgImageRequest = ImagePipeline.shared.rx.loadImage(with: bgUrl).asObservable()
            var fgImageRequest = ImagePipeline.shared.rx.loadImage(with: fgUrl).asObservable()
            Observable.combineLatest(bgImageRequest,fgImageRequest)
                .subscribe(onNext: { bgImageResponse,fgImageResponse in
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.applyRealisticCartoonOnImage(index: index,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.applyNewProfilePicOnImage(index: index,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .styleTransfer {
                        self.applyStyleTransferOnImage(index: index)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        self.applyFunnyCaricaturesOnImage(index: index,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    
            }).disposed(by: disposeBag)
        }
        else {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            ImagePipeline.shared.rx.loadImage(with: bgUrl)
                .subscribe(onSuccess: {
                    var effectBackImage = $0.image
                   
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.applyRealisticCartoonOnImage(index: index ,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.applyNewProfilePicOnImage(index: index,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .styleTransfer {
                        self.applyStyleTransferOnImage(index: index)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        self.applyFunnyCaricaturesOnImage(index: index,effectBackImage:effectBackImage,effectFrontImage: nil)
                    }
                    
                },onFailure: { [self] error in
                    DispatchQueue.main.async {
                        self.stopProgressBar()
                        self.showImageLoadingErrorAlert()
                    }
            }).disposed(by: disposeBag)
        }
    }
    
    func applyRealisticCartoonOnImage(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:Router.shared.image!, backgroundUIImage: effectBackImage!.resized(to: CGSize(width: 1500, height:1500 ), scale: 1))
            Router.shared.outPutImage = swappedImage
            DispatchQueue.main.async {
                self.effectView?.bgImageView?.image  = swappedImage
                self.stopProgressBar()
            }
        }
    }

    func applyNewProfilePicOnImage(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
               var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!.resized(to: CGSize(width: 1500, height:1500 ), scale: 1), withImage: Router.shared.image!)
               if effectFrontImage != nil {
                   swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!.resized(to: CGSize(width: 1500, height:1500 ), scale: 1))
               }
               Router.shared.outPutImage = swappedImage
               DispatchQueue.main.async {
                   self.effectView?.bgImageView?.image  = swappedImage
                   self.stopProgressBar()

               }
           }
       }

    func applyFunnyCaricaturesOnImage(index: Int,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            DispatchQueue.main.async {
                effectView?.bgImageView?.image = effectBackImage
                effectView?.profileImageView?.image = Router.shared.image!
                if effectFrontImage != nil {
                    effectView?.fgImageView?.image = effectFrontImage
                }
                self.emptyEffectImage.isHidden = true
                self.emptyEffectLabel.isHidden = true
                Router.shared.outPutImage = Router.shared.image!
                self.stopProgressBar()
            }
       }
    }
    
    func applyStyleTransferOnImage(index: Int) {
        self.startProgressBar()

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
                self.stopProgressBar()
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
