//
//  DrawingVC.swift
//  cartoon
//
//  Created by pawan kumar on 04/10/22.
//

import UIKit
import Nuke
import RxSwift

class DrawingVC: BaseVC {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var bannerView: UIView!

    public var item: Items?
    var semanticImage = SemanticImage()
    internal var disposeBag = DisposeBag()
    
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
                var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
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
                if item != nil {
                    loadSelectedEffect()
                }
                else {
                    self.stopProgressBar()
                    let vc = EditVC.instantiate()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}


extension DrawingVC {
    
    func loadSelectedEffect() {
        let thumbUrl = self.item?.icon
        let bgImageUrl = self.item?.bg
        let fgImageUrl = self.item?.fg
        
        debugPrint("bgImageUrl test:",bgImageUrl)
        debugPrint("fgImageUrl test:",fgImageUrl)
        self.startProgressBar()
        
        if fgImageUrl != nil && fgImageUrl != String.empty  && (fgImageUrl?.count ?? 0) > 5 {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            var fgUrl = URL(string: NetworkConstants.baseS3Url + (fgImageUrl ?? String.empty) )!
            var bgImageRequest = ImagePipeline.shared.rx.loadImage(with: bgUrl).asObservable()
            var fgImageRequest = ImagePipeline.shared.rx.loadImage(with: fgUrl).asObservable()
            Observable.combineLatest(bgImageRequest,fgImageRequest)
                .subscribe(onNext: { [self] bgImageResponse,fgImageResponse in
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.applyRealisticCartoonOnImage(item: item!,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.applyNewProfilePicOnImage(item: item!,effectBackImage: bgImageResponse.image,effectFrontImage: fgImageResponse.image)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        //Not required
                    }
                    
                }).disposed(by: disposeBag)
        }
        else {
            var bgUrl = URL(string: NetworkConstants.baseS3Url + (bgImageUrl ?? String.empty) )!
            ImagePipeline.shared.rx.loadImage(with: bgUrl)
                .subscribe(onSuccess: { [self] in
                    var effectBackImage = $0.image
                    
                    if Router.shared.currentEffect == .realisticCartoon {
                        self.applyRealisticCartoonOnImage(item: self.item! ,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .newProfilePic {
                        self.applyNewProfilePicOnImage(item: item!,effectBackImage: effectBackImage,effectFrontImage: nil)
                    }
                    else if Router.shared.currentEffect == .funnyCaricatures {
                        //Not required
                    }
                    
                },onFailure: { [self] error in
                    DispatchQueue.main.async {
                        self.stopProgressBar()
                        self.showImageLoadingErrorAlert()
                    }
                }).disposed(by: disposeBag)
        }
    }
    
    
    func applyRealisticCartoonOnImage(item: Items,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            let swappedImage:UIImage? = semanticImage.saliencyBlend(objectUIImage:Router.shared.image!, backgroundUIImage: effectBackImage!.resized(to: CGSize(width: 1500, height:1500 ), scale: 1))
            Router.shared.outPutImage = swappedImage
            DispatchQueue.main.async {
                self.stopProgressBar()
                let vc = ShareVC.instantiate()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func applyNewProfilePicOnImage(item: Items,effectBackImage: UIImage?,effectFrontImage: UIImage?) {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
               var swappedImage:UIImage? = UIImage.imageByCombiningImage(firstImage: effectBackImage!.resized(to: CGSize(width: 1500, height:1500 ), scale: 1), withImage: Router.shared.image!)
               if effectFrontImage != nil {
                   swappedImage =  UIImage.imageByCombiningImage(firstImage: swappedImage!, withImage: effectFrontImage!.resized(to: CGSize(width: 1500, height:1500 ), scale: 1))
               }
               Router.shared.outPutImage = swappedImage
               DispatchQueue.main.async {
                   self.stopProgressBar()
                   let vc = ShareVC.instantiate()
                   self.navigationController?.pushViewController(vc, animated: true)
               }
           }
       }
    
}

