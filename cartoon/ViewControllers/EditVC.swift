//
//  EditVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import SwiftLoader
import Nuke
import RxSwift
import ZLImageEditor

class EditVC: BaseVC {

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var effectView:EffectView?
    @IBOutlet weak var effectsCategoriesView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView?
    @IBOutlet weak var subCategoryCollectionView: UICollectionView?

    var semanticImage = SemanticImage()
  
    var categories:[Categories] = []
    var items:[Items] = []
    
    var selecteSubCategoryIndex = 0
    var selecteCategoryIndex = 0
    
    var isColorModuleVisible = false
    
    internal var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        setupView()
        initialiseCategoryData()
        if categories.count > 0 {
            self.selectCategoryItemAt(index: 0)
        }
    }
    
    func setupView() {
        self.effectView?.bgImageView?.image =  UIImage(named: "empty_edit_place_holder")
        effectsCategoriesView.backgroundColor = .clear
        subCategoryCollectionView?.backgroundColor = .clear
        categoryCollectionView?.backgroundColor = .clear
    }
    
    func registerCollectionCell() {
        self.categoryCollectionView?.register(EffectViewCell.getNib(), forCellWithReuseIdentifier: EffectViewCell.reuseIdentifier)
        self.subCategoryCollectionView?.register(ColorViewCell.getNib(),forCellWithReuseIdentifier: ColorViewCell.reuseIdentifier)
        self.subCategoryCollectionView?.register(EffectViewCell.getNib(), forCellWithReuseIdentifier: EffectViewCell.reuseIdentifier)
        self.categoryCollectionView?.register(ColorViewCell.getNib(),forCellWithReuseIdentifier: ColorViewCell.reuseIdentifier)
    }
    
    func initialiseCategoryData() {
        self.categories.removeAll()
        
        //initialise style transfer
        if  Router.shared.currentEffect == .styleTransfer {
           initializeStyleTransferBackgrounds()
            return
       }
        else {
            //initialise category
            var effectsData:EffectsManager?
            if  Router.shared.currentEffect == .realisticCartoon {
                effectsData = EffectsManager.loadFullChangeoverData()

            }
            else  if  Router.shared.currentEffect == .newProfilePic {
                effectsData = EffectsManager.loadRealisticCartoonData()
            }
            else  if  Router.shared.currentEffect == .funnyCaricatures {
//                effectsData = EffectsManager.loadFullChangeoverData()
                effectsData = EffectsManager.loadToonAvatarsData()

            }
            
            if let categories = effectsData?.categories  {
                for data in categories {
                    if data.icon != nil {
                        self.categories.append(data)
                    }
                }
            }
        }
        self.categoryCollectionView?.reloadData()
    }
    
    func refreshSubCategoryData(index:Int) {
        self.items.removeAll()
        if let category = categories[safeIndex: index]  {
            for data in category.items ?? [] {
                if data.bg != nil && data.icon != nil{
                    self.items.append(data)
                }
            }
        }
        self.subCategoryCollectionView?.reloadData()
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Call First Style of effect
    }

}


extension EditVC:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if categoryCollectionView == collectionView {
            return self.categories.count
        }
        else {
           return self.items.count
        }
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if categoryCollectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.reuseIdentifier, for: indexPath) as! ColorViewCell
           if Router.shared.currentEffect == .styleTransfer {
               let thumbUrl = self.categories[indexPath.row].icon
               cell.imageView.image = UIImage(named: thumbUrl!)
            }
            else {
                let thumbUrl = self.categories[indexPath.row].icon
                cell.imageView.image = nil
                var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
                Nuke.loadImage(with: url, into: cell.imageView)
            }
            cell.setupUI(isSelected: indexPath.row == self.selecteCategoryIndex)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectViewCell.reuseIdentifier, for: indexPath) as! EffectViewCell
            
            
            let thumbUrl = self.items[indexPath.row].icon
            
            if Router.shared.currentEffect == .styleTransfer {
                let thumbUrl = self.categories[indexPath.row].icon
                cell.imageView.image = UIImage(named: thumbUrl!)
             }
            else {
                cell.imageView.image = nil
                var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
                Nuke.loadImage(with: url, into: cell.imageView)
                cell.setupUI(isSelected: indexPath.row == self.selecteSubCategoryIndex)
            }

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if categoryCollectionView == collectionView {
            return CGSize(width: 75, height: 75)
        }
        else {
            return CGSize(width: 100, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if categoryCollectionView == collectionView {
            self.selectCategoryItemAt(index: indexPath.row)
        }
        else {
            self.selectSubCategoryItemAt(index: indexPath.row)
        }
    }
    
    func selectCategoryItemAt(index: Int) {
        self.selecteCategoryIndex = index
        if Router.shared.currentEffect == .styleTransfer {
            self.createStyleTransfer(index: index)
        }
        else {
            refreshSubCategoryData(index: index)
            selectSubCategoryItemAt(index: 0)
        }
        self.categoryCollectionView?.reloadData()

     }
    
    func selectSubCategoryItemAt(index: Int) {
        self.selecteSubCategoryIndex = index
        loadEffectImages(index: index)
     }
}

extension EditVC {
    
    @IBAction func doneBtnClick(_ sender: UIButton) {
        let vc = ShareVC.instantiate()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
    
    
    @IBAction func editAction(_ sender: UIButton) {
        guard (Router.shared.outPutImage != nil) else {
            return
        }
        
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image:self.effectView?.bgImageView?.image  ?? UIImage(), editModel: nil) { [weak self] (resImage, editModel) in
            // your code
            self?.effectView?.bgImageView?.image  = resImage
            Router.shared.outPutImage = resImage
        }
    }
}

