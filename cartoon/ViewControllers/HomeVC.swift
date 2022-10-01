//
//  HomeVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import YPImagePicker
import SSSpinnerButton

class HomeVC: BaseVC {
    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var notificationButton: UIButton!
    
    @IBOutlet weak var effectsButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!

    @IBOutlet weak var cardCollectionView: UICollectionView?
    @IBOutlet weak var navTitle: UILabel!
    @IBOutlet weak var adsBannerView: UIView!
    
    var semanticImage = SemanticImage()
    var cards:[Card] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.effectsButton.isSelected = true
        registerCollectionCell()
        Router.shared.navigationController = self.navigationController
        cardCollectionView?.reloadData()
    }
    
    func registerCollectionCell() {
        self.cardCollectionView?.register(DynamicCardCell.getNib(), forCellWithReuseIdentifier: DynamicCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(RealisticCartoonCardCell.getNib(),forCellWithReuseIdentifier: RealisticCartoonCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(ProfilePicCardCell.getNib(),forCellWithReuseIdentifier: ProfilePicCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(StyleTransferCardCell.getNib(),forCellWithReuseIdentifier: StyleTransferCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(FullBodyCardCell.getNib(),forCellWithReuseIdentifier: FullBodyCardCell.reuseIdentifier)
     }
    
    @IBAction func settingBtnClick(_ sender: UIButton) {
        let vc = SettingsVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func notificationBtnClick(_ sender: UIButton) {
        //We might remove this fetures
        let proVC = GoProVC.instantiate()
        proVC.modalPresentationStyle = .fullScreen
        self.present(proVC, animated: true, completion: nil)
    }
    
    @IBAction func updateCategories(_ sender: UIButton) {
        effectsButton.isSelected = false
        popularButton.isSelected = false
        trendingButton.isSelected = false
        sender.isSelected = true
        if sender == effectsButton {
       
        }
        else if sender == popularButton {
            
        }
        else if sender == trendingButton {

        }
    }
    
    @IBAction func tryBtnClick(_ sender: UIButton) {
        let index = (sender as AnyObject).tag
        if index == 0 {
            Router.shared.currentEffect = .realisticCartoon
        }
        else if index == 1 {
            Router.shared.currentEffect = .newProfilePic
        }
        else if index == 2 {
            Router.shared.currentEffect = .styleTransfer
        }
        else if index == 3 {
            Router.shared.currentEffect = .funnyCaricatures
        }
        selectPhotoAction()
//        let userImage:UIImage = UIImage(named: "demo_10")! //5,6,12
//        Router.shared.image = userImage
//        let vc = EditVC.instantiate()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeVC:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 // first for static cards and second for dyanamic cards
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section  == 0 {
            return  Constants.cards.count
        }
        else {
            return 0 //will add dynamic cards
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        if indexPath.section  == 0 {
            
            if indexPath.row == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RealisticCartoonCardCell.reuseIdentifier, for: indexPath) as! RealisticCartoonCardCell
                self.setupCardCell(cardCell: cell, cellForItemAt: indexPath)
                return cell
            }
            else if indexPath.row == 1 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfilePicCardCell.reuseIdentifier, for: indexPath) as! ProfilePicCardCell
                self.setupCardCell(cardCell: cell, cellForItemAt: indexPath)
                return cell
            }
            else if indexPath.row == 2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleTransferCardCell.reuseIdentifier, for: indexPath) as! StyleTransferCardCell
                self.setupCardCell(cardCell: cell, cellForItemAt: indexPath)
                return cell
            }
            else if indexPath.row == 3 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FullBodyCardCell.reuseIdentifier, for: indexPath) as! FullBodyCardCell
                self.setupCardCell(cardCell: cell, cellForItemAt: indexPath)
                return cell
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DynamicCardCell.reuseIdentifier, for: indexPath) as! DynamicCardCell
                self.setupCardCell(cardCell: cell, cellForItemAt: indexPath)
                return cell
            }
        }
        else {
            //Configure dyanamic crads
        }
        return UICollectionViewCell()
    }
    
    func setupCardCell(cardCell:BaseCardCell, cellForItemAt indexPath: IndexPath) {
        let effect = Constants.cards[indexPath.row]
        cardCell.tryButton.tag = indexPath.row
        cardCell.titleLabel.text = effect.titleText
        cardCell.descLabel.text = effect.descText
        cardCell.tryButton.addTarget(self, action: #selector(HomeVC.tryBtnClick(_:)), for: .touchUpInside)
    }
}


extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = (self.view.frame.size.width - 40)
        return CGSize(width: screenWidth, height: screenWidth * 0.6)
    }
}

extension HomeVC {
    
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
                            // let vc = ImageSelectorVC.instantiate()
                            let vc = EditVC.instantiate()
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else {
                            print("FACE NOT FOUND")
                            let actionYes : [String: () -> Void] = [ "Try again" : { (
                                    print("tapped YES")
                            ) }]
                            let actionNo : [String: () -> Void] = [ "No" : { (
                                print("tapped NO")
                            ) }]
                            let arrayActions = [actionYes, actionNo]

                            self.showCustomAlertWith(
                                message: "Unable to find face in that Image",
                                descMsg: "Please select different Image",
                                itemimage: nil,
                                actions: arrayActions)
                            
                        }
                    }
                }
            }
        }
        present(picker, animated: true, completion: nil)
    }
}





//
//
//
//import SSSpinnerButton
//
//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}
//
//extension  ViewController {
//    
//    @IBAction func popUpButtonAction_(_ sender: SSSpinnerButton) {
//        sender.startAnimate(spinnerType: .ballSpinFade, spinnercolor: .white, spinnerSize: 20, complete: nil)
//        
//        let actionYes : [String: () -> Void] = [ "YES" : { (
//                print("tapped YES")
//        ) }]
//        let actionNo : [String: () -> Void] = [ "No" : { (
//            print("tapped NO")
//        ) }]
//        let arrayActions = [actionYes, actionNo]
//
//        self.showCustomAlertWith(
//            message: "This is an alert with a logo, message, additional icon, description, and 2 buttons with handlers",
//            descMsg: "your description goes here. Change font size from XiB file.",
//            itemimage: nil,
//            actions: arrayActions)

////        sender.stopAnimatingWithCompletionType(completionType: .fail, complete: {
////            // Your completion actions
////        })
//        
//    }
//}
