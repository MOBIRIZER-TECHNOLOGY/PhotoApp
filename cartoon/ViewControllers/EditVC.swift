//
//  EditVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit
import Nuke
import RxSwift
import ZLImageEditor

class EditVC: BaseVC {

    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var effectView:EffectView?
    @IBOutlet weak var effectsCategoriesView: UIView!
    @IBOutlet weak var categoryCollectionView: UICollectionView?
    @IBOutlet weak var subCategoryCollectionView: UICollectionView?

    let progressBarsStackView: LinearProgressBar = {
        let progressBar = LinearProgressBar()
        progressBar.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        progressBar.progressBarColor = .systemOrange
        progressBar.progressBarWidth = 7
        progressBar.cornerRadius = 2
        return progressBar
    }()
    
    var semanticImage = SemanticImage()
  
    var categories:[Categories] = []
    var items:[Items] = []
    
    var selecteSubCategoryIndex = 0
    var selecteCategoryIndex = 0
    
    @IBOutlet weak var effectTopMarginConstraint: NSLayoutConstraint!
    var isColorModuleVisible = false
    
    @IBOutlet weak var emptyEffectImage: UIImageView!
    @IBOutlet weak var emptyEffectLabel: UILabel!

    internal var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCollectionCell()
        setupView()
        initialiseCategoryData()
        prepareDemoProgressBars()
        createEffects()
    }

    func prepareDemoProgressBars() {
        progressBarsStackView.translatesAutoresizingMaskIntoConstraints = false
        effectView?.addSubview(progressBarsStackView)
        progressBarsStackView.centerYAnchor.constraint(equalTo: effectView!.bottomAnchor, constant: -7).isActive = true
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateLayoutMargin()
    }
    
    func updateLayoutMargin() {
        let topViewHeight = 160
        var bottomViewHeight = 200
        if  Router.shared.currentEffect == .styleTransfer {
            bottomViewHeight -= 70
       }
        let screenHeight:  CGFloat = UIScreen.main.bounds.height
        let screenWidth: CGFloat = self.effectView?.frame.size.height ?? 0

        let blankSpaceHeight = (Int(screenHeight - screenWidth) - topViewHeight - bottomViewHeight)
        let topMargin = CGFloat(blankSpaceHeight/2) < 0 ? 0 : CGFloat(blankSpaceHeight/2)
        effectTopMarginConstraint.constant = topMargin

    }
    func setupView() {
        effectsCategoriesView.backgroundColor = .clear
        subCategoryCollectionView?.backgroundColor = .clear
        categoryCollectionView?.backgroundColor = .clear
    }
    
    func registerCollectionCell() {
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
                effectsData = EffectsManager.loadToonAvatarsData()
            }
            
            if let categories = effectsData?.categories  {
                for data in categories {
                    if data.icon != nil && (data.items?.count ?? 0) > 0 {
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
        self.items = self.items.reversed()
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
        
        if Router.shared.currentEffect == .styleTransfer {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectViewCell.reuseIdentifier, for: indexPath) as! EffectViewCell
            let thumbUrl = self.items[indexPath.row].icon
            cell.imageView.image = UIImage(named: thumbUrl!)
            cell.setupUI(isSelected: indexPath.row == self.selecteSubCategoryIndex)
            return cell
         }
        
        if categoryCollectionView == collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorViewCell.reuseIdentifier, for: indexPath) as! ColorViewCell
            let thumbUrl = self.categories[indexPath.row].icon
            cell.imageView.image = nil
            var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
            Nuke.loadImage(with: url, into: cell.imageView)
            cell.setupUI(isSelected: indexPath.row == self.selecteCategoryIndex)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EffectViewCell.reuseIdentifier, for: indexPath) as! EffectViewCell
            cell.imageView.image = nil
            let thumbUrl = self.items[indexPath.row].icon
            var url = URL(string: NetworkConstants.baseS3Url + (thumbUrl ?? String.empty) )!
            Nuke.loadImage(with: url, into: cell.imageView)
            cell.setupUI(isSelected: indexPath.row == self.selecteSubCategoryIndex)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if categoryCollectionView == collectionView {
            return CGSize(width: 75, height: 75)
        }
        else {
            return CGSize(width: 70, height: 90)
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
        if Router.shared.currentEffect == .styleTransfer {
            self.selecteSubCategoryIndex = index
            self.applyStyleTransferOnImage(index: index)
        }
        else {
            self.selecteCategoryIndex = index
            refreshSubCategoryData(index: index)
            selectSubCategoryItemAt(index: 0)
        }
        self.categoryCollectionView?.reloadData()
        self.subCategoryCollectionView?.reloadData()
     }
    
    func selectSubCategoryItemAt(index: Int) {
        self.selecteSubCategoryIndex = index
        if Router.shared.currentEffect == .styleTransfer {
            self.applyStyleTransferOnImage(index: index)
        }
        else {
            loadEffectImages(index: index)
        }
        self.subCategoryCollectionView?.reloadData()

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


extension EditVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if #available(iOS 13, *) {
            let verticalIndicatorView = (scrollView.subviews[(scrollView.subviews.count - 1)].subviews[0])
            let horizontalIndicatorView = (scrollView.subviews[(scrollView.subviews.count - 2)].subviews[0])
            
            verticalIndicatorView.backgroundColor = UIColor.orange
            horizontalIndicatorView.backgroundColor = UIColor.orange
            
        } else {
            if let verticalIndicatorView: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as? UIImageView) {
                verticalIndicatorView.backgroundColor = UIColor.orange
            }
            if let horizontalIndicatorView: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 2)] as? UIImageView) {
                horizontalIndicatorView.backgroundColor = UIColor.orange
            }
        }
   }
}
