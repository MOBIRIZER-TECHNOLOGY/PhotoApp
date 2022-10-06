//
//  HomeVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import YPImagePicker
import SSSpinnerButton
import Nuke

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
    
    var popularItems:[Items] = []
    var trendingItems:[Items] = []
    
    let flowlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return layout
    }()
    
    let pinterestLayout: PinterestLayout = {
        var layout = PinterestLayout()
        layout.columnsCount = 2
        layout.contentPadding = PinterestLayout.Padding(horizontal: 5, vertical: 5)
        layout.cellsPadding = PinterestLayout.Padding(horizontal: 10, vertical: 10)
        return layout
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialisePopularAndTrendingData()
        Router.shared.selectedTabIndex = 0
        self.effectsButton.isSelected = true
        registerCollectionCell()
        Router.shared.navigationController = self.navigationController
        cardCollectionView?.setCollectionViewLayout(flowlayout, animated: true)
        cardCollectionView?.reloadData()
    }
    
    func registerCollectionCell() {
        self.cardCollectionView?.register(DynamicCardCell.getNib(), forCellWithReuseIdentifier: DynamicCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(RealisticCartoonCardCell.getNib(),forCellWithReuseIdentifier: RealisticCartoonCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(ProfilePicCardCell.getNib(),forCellWithReuseIdentifier: ProfilePicCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(StyleTransferCardCell.getNib(),forCellWithReuseIdentifier: StyleTransferCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(FullBodyCardCell.getNib(),forCellWithReuseIdentifier: FullBodyCardCell.reuseIdentifier)
        
        self.cardCollectionView?.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)

     }
    
    @IBAction func settingBtnClick(_ sender: UIButton) {
        let vc = SettingsVC.instantiate()
        self.present(vc, animated: true)
    }
    
    @IBAction func notificationBtnClick(_ sender: UIButton) {
        //We might remove this fetures
        let proVC = GoProVC.instantiate()
        proVC.modalPresentationStyle = .fullScreen
        self.present(proVC, animated: true, completion: nil)
//        super.settingPopOver(self)
    }
    
    @IBAction func updateCategories(_ sender: UIButton) {
        effectsButton.isSelected = false
        popularButton.isSelected = false
        trendingButton.isSelected = false
        sender.isSelected = true
        if sender == effectsButton {
            self.cardCollectionView?.reloadData()
            self.cardCollectionView?.collectionViewLayout.invalidateLayout()
            Router.shared.selectedTabIndex = 0
            self.cardCollectionView?.setCollectionViewLayout(flowlayout, animated: true)
            self.cardCollectionView?.reloadData()
            self.cardCollectionView?.setContentOffset(CGPoint.zero, animated: false)

        }
        else if sender == popularButton {
            self.cardCollectionView?.reloadData()
            self.cardCollectionView?.collectionViewLayout.invalidateLayout()
            Router.shared.selectedTabIndex = 1
            self.cardCollectionView?.setCollectionViewLayout(pinterestLayout, animated: true)
            pinterestLayout.delegate = self as PinterestLayoutDelegate
            self.cardCollectionView?.reloadData()
            self.cardCollectionView?.setContentOffset(CGPoint.zero, animated: false)

        }
        else if sender == trendingButton {
            self.cardCollectionView?.reloadData()
            self.cardCollectionView?.collectionViewLayout.invalidateLayout()
            Router.shared.selectedTabIndex = 2
            self.cardCollectionView?.setCollectionViewLayout(pinterestLayout, animated: true)
            pinterestLayout.delegate = self as PinterestLayoutDelegate
            self.cardCollectionView?.reloadData()
            self.cardCollectionView?.setContentOffset(CGPoint.zero, animated: false)

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
        selectPhotoAction(item: nil)
//        let userImage:UIImage = UIImage(named: "demo_10")! //5,6,12
//        Router.shared.image = userImage
//        let vc = DrawingVC.instantiate()
//        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeVC:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Router.shared.selectedTabIndex == 1 {
           let item = self.popularItems[indexPath.row]
            selectPhotoAction(item: item)

       }  else if Router.shared.selectedTabIndex == 1 {
           let item = self.trendingItems[indexPath.row]
           selectPhotoAction(item: item)
       }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1 // first for static cards and second for dyanamic cards
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if Router.shared.selectedTabIndex == 0 {
            return  Constants.cards.count
        }
        else if Router.shared.selectedTabIndex == 1 {
            return popularItems.count
        }
        else if Router.shared.selectedTabIndex == 2 {
            return trendingItems.count
        }
        else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        if Router.shared.selectedTabIndex == 0 {
            
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
        else if Router.shared.selectedTabIndex == 1 {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell
        
            let thumbUrl = self.popularItems[indexPath.row].icon
            var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
            Nuke.loadImage(with: url, into: cell.imageView)
 
            cell.imageContentMode = .scaleAspectFit
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell

            let thumbUrl = self.trendingItems[indexPath.row].icon
            var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
            Nuke.loadImage(with: url, into: cell.imageView)
            
            cell.imageContentMode = .scaleAspectFit
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 10
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
            return cell
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
    
    func selectPhotoAction( item: Items?) {
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
                            let vc = DrawingVC.instantiate()
                            vc.item = item
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

extension HomeVC: PinterestLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        var height = 100.0
        var width = 100.0
        if indexPath.row % 2 == 0{
            height = 100
            width = 100
        }

        let cellWidth = pinterestLayout.width
        let size = CGSize(width: Int(cellWidth), height: Int((height/width) * cellWidth))
        return size
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
