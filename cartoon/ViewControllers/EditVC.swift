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
    @IBOutlet weak var effectsCollectionView: UICollectionView?
    @IBOutlet weak var colorsCollectionView: UICollectionView?

    var semanticImage = SemanticImage()
    var effects:[Effect] = []
    var colors:[ColorEffect] = []
    var selectedColorIndex = 0
    var selecteEffectIndex = 0
    var isColorModuleVisible = false
    
    internal var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        setupView()
        loadEffectsData()
        loadColorsData()
        self.selectItemAt(indexPath: IndexPath(row: 0, section: 0))
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
        var effectsData:EffectsCodable?
        self.effects.removeAll()

        if  Router.shared.currentEffect == .realisticCartoon {
//            effectsData = EffectsCodable.loadFullChangeoverData()
            effectsData = EffectsCodable.loadToonAvatarsData()
//            effectsData = EffectsCodable.loadRealisticCartoonData()

            if let effects = effectsData?.effects  {
                for data in effects {
                    var obj = Effect(thumbUrl: data.thumbUrl, bgImageUrl: data.bgImageUrl, fgImageUrl: data.fgImageUrl, blendHashKey: String.empty, name: String.empty)
                    if obj.thumbUrl != nil && obj.bgImageUrl != nil {
                        self.effects.append(obj)
                    }
                }
            }
            
        }
        else  if  Router.shared.currentEffect == .newProfilePic {
            effectsData = EffectsCodable.loadRealisticCartoonData()
//            effectsData = EffectsCodable.loadToonAvatarsData()

            if let effects = effectsData?.effects  {
                for data in effects {
                    var obj = Effect(thumbUrl: data.thumbUrl, bgImageUrl: data.bgImageUrl, fgImageUrl: data.fgImageUrl, blendHashKey: String.empty, name: String.empty)
                    
                    if obj.thumbUrl != nil && obj.bgImageUrl != nil  {
                        self.effects.append(obj)
                    }
                }
            }
        }
        else  if  Router.shared.currentEffect == .styleTransfer {
            initializeStyleTransferBackgrounds()
        }
        else  if  Router.shared.currentEffect == .funnyCaricatures {
//            effectsData = EffectsCodable.loadToonAvatarsData()
            effectsData = EffectsCodable.loadFullChangeoverData()

            if let effects = effectsData?.effects  {
                for data in effects {
                    var obj = Effect(thumbUrl: data.thumbUrl, bgImageUrl: data.bgImageUrl, fgImageUrl: data.fgImageUrl, blendHashKey: String.empty, name: String.empty)
                    
                    if obj.thumbUrl != nil  && obj.bgImageUrl != nil {
                        self.effects.append(obj)
                    }
                }
            }
        }

        self.effectsCollectionView?.reloadData()
    }
    
    func loadColorsData() {
        return
        var effectsData:EffectsCodable?
        if  Router.shared.currentEffect == .realisticCartoon {
            effectsData = EffectsCodable.loadFullChangeoverData()
        }
        else  if  Router.shared.currentEffect == .newProfilePic {
            effectsData = EffectsCodable.loadRealisticCartoonData()
        }
        else  if  Router.shared.currentEffect == .styleTransfer {
            // Will show color plate
        }
        else  if  Router.shared.currentEffect == .funnyCaricatures {
            effectsData = EffectsCodable.loadToonAvatarsData()
            
        }
        self.colors.removeAll()
        if let effects = effectsData?.effects  {
            for data in effects {
                var data = ColorEffect(iconImage: data.thumbUrl!, backgroundImage: data.bgImageUrl ?? String.empty, blendHashKey: String.empty, name: String.empty)
                self.colors.append(data)
            }
        }
        self.colorsCollectionView?.reloadData()
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
           if Router.shared.currentEffect == .styleTransfer {
               
               let thumbUrl = self.effects[indexPath.row].thumbUrl
               cell.imageView.image = UIImage(named: thumbUrl!)
            }
            else {
                let thumbUrl = self.effects[indexPath.row].thumbUrl
                let bgImageUrl = self.effects[indexPath.row].bgImageUrl
                let fgImageUrl = self.effects[indexPath.row].fgImageUrl

                cell.imageView.image = nil
                var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
                Nuke.loadImage(with: url, into: cell.imageView)
            }
            
  
            cell.setupUI(isSelected: indexPath.row == self.selecteEffectIndex)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.reuseIdentifier, for: indexPath) as! ColorViewCell
            
            let thumbUrl = self.effects[indexPath.row].thumbUrl
            let bgImageUrl = self.effects[indexPath.row].bgImageUrl

            cell.imageView.image = nil
            var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
            Nuke.loadImage(with: url, into: cell.imageView)
            cell.setupUI(isSelected: indexPath.row == self.selectedColorIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if effectsCollectionView == collectionView {
            return CGSize(width: 100, height: 100)
        }
        else {
            return CGSize(width: 75, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if effectsCollectionView == collectionView {
            self.selecteEffectIndex = indexPath.row
            self.effectsCollectionView?.reloadData()
            self.selectItemAt(indexPath: indexPath)
        }
        else {
            self.selectedColorIndex = indexPath.row
            self.colorsCollectionView?.reloadData()
//            let effectBackground = self.colors[indexPath.row]
//            self.selectItemAt(indexPath: indexPath)
        }
    }
    
    func selectItemAt(indexPath: IndexPath) {
        if Router.shared.currentEffect == .styleTransfer {
            self.createStyleTransfer(indexPath: indexPath)
        }
        else {
            loadEffectImages(indexPath: indexPath)
        }
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

