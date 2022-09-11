//
//  ViewController.swift
//  BgEraser
//
//  Created by Narender Kumar on 08/08/22.
//

import UIKit
import SSCustomSideMenu
import YPImagePicker
import ToastViewSwift
import GoogleMobileAds

class ViewController: BaseVC {
    
    @IBOutlet weak var sideMenuBtn: SSMenuButton!
    @IBOutlet weak var effectsCollectionView: UICollectionView?
    var semanticImage = SemanticImage()
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        Router.shared.navigationController = self.navigationController
        self.sideMenuBtn.setTitle(String.empty, for: .normal)
        effectsCollectionView?.reloadData()
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-9915443997240109/4712825220"
        bannerView.rootViewController = self
        addBannerViewToView(bannerView)
    }
    
    func selectPhotoAction() {
        // Here we configure the picker to only show videos, no photos.
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo]
        config.library.mediaType = .photo
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [self, unowned picker] items, cancelled in
            picker.dismiss(animated: true) {
                if cancelled == false {
                if let photo = items.singlePhoto {
                    Router.shared.image = photo.image
                    var faceImage:UIImage? = semanticImage.faceRectangle(uiImage:Router.shared.image!)?.resized(to: CGSize(width: 1200, height:1200), scale: 1)
                    if (faceImage != nil) {
                        let vc = ImageSelectorVC.instantiate()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        print("FACE NOT FOUND")
                        self.showToast(controller: self.navigationController!, message: "Please select different Image as Unable to find face in that Image", seconds: 10.0)
 
                    }
                }
               }
            }
        }
        present(picker, animated: true, completion: nil)
    }
}


extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  Constants.effects.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.effectCellIdentifier, for: indexPath) as! EffectsCollectionViewCell
        let effect = Constants.effects[indexPath.row]
        cell.titleLabel.text = effect.titleText
        cell.descLabel.text = effect.descText
        cell.effectImageViewFirst.image = UIImage(named: effect.imageFirst)
        cell.effectImageViewSecond.image = UIImage(named: effect.imageSecond)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Router.shared.currentEffect = .realisticCartoon
        }
        else if indexPath.row == 1 {
            Router.shared.currentEffect = .newProfilePic
        }
        else if indexPath.row == 2 {
            Router.shared.currentEffect = .styleTransfer
        }
        else if indexPath.row == 3 {
            Router.shared.currentEffect = .funnyCaricatures
        }
        
//        let numbers = [0]
//        let _ = numbers[1]
        
        selectPhotoAction()
//        let userImage:UIImage = UIImage(named: "demo_10")! //5,6,12
//        Router.shared.image = userImage
//        let vc = ImageSelectorVC.instantiate()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
       }
    }


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (self.view.frame.size.width - 12)
        return CGSize(width: screenWidth, height: 250)
    }
}

