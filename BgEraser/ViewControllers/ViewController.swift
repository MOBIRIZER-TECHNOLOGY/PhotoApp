//
//  ViewController.swift
//  BgEraser
//
//  Created by Narender Kumar on 08/08/22.
//

import UIKit
import SSCustomSideMenu
import SwiftUI
import SwiftLoader
import ZLImageEditor
import YPImagePicker

private let reuseIdentifier = "Cell"

class ViewController: UIViewController {
    
    @IBOutlet weak var sideMenuBtn: SSMenuButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView?

    @IBOutlet weak var cityCollectionView: UICollectionView?

    var cities : [City] = [
                                    City(image: "Antalya", name: "Effects-1"),
                                    City(image: "Aydin", name: "Effects-2"),
                                    City(image: "Bodrum", name: "Effects-3"),
                                    City(image: "Canakkale", name: "Effects-4"),
                                    City(image: "Cappadocia", name: "Effects-5"),
                                    City(image: "Efes", name: "Effects-6"),
                                    City(image: "Eskisehir", name: "Effects-7")
    ]
                                    

    var image: UIImage? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuBtn.setTitle("", for: .normal)
        self.shareBtn.setTitle("", for: .normal)
        self.imageView?.image =  UIImage(named: "placeholder")
    }
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        // Here we configure the picker to only show videos, no photos.
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo]
        config.library.mediaType = .photo
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.imageView?.image = photo.image
                self.image = photo.image
     
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
  
    @IBAction func shareAction(_ sender: UIButton) {
        guard (self.image != nil) else {
            return
        }
        
        // set up activity view controller
        let imageToShare = [ self.imageView?.image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: UIButton) {
        guard (self.image != nil) else {
            return
        }
        
        ZLImageEditorConfiguration.default()
            .editImageTools([.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter, .adjust])
            .adjustTools([.brightness, .contrast, .saturation])

        ZLEditImageViewController.showEditImageVC(parentVC: self, image:self.imageView?.image ?? UIImage(), editModel: nil) { [weak self] (resImage, editModel) in
            // your code
            self?.imageView?.image = resImage
            self?.image = resImage
            
        }
    }
}


extension ViewController:  UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return cities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dataCell", for: indexPath) as! EffectsCollectionViewCell
    
        // Configure the cell
        
        let city = cities[indexPath.row]
        cell.cityImageView.image = UIImage(named: city.image)
        cell.cityNameLabel.text = city.name
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("collectionView didSelectItemAt:")
        guard (self.image != nil) else {
            return
        }
        
        SwiftLoader.show(title: "Processing please wait...", animated: true)
        self.imageView?.image = nil
        
        let iCount = indexPath.row
        
        if iCount == 1 {
            let  output = self.image?.applyNightEffects(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }
        else if iCount == 2 {
            let  output = self.image?.applyMosicEffects(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }
        else if iCount  == 3 {
            let  output = self.image?.applyCupheadEffects(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }
        else if iCount == 4 {
            let  output = self.image?.applyPaintEffects(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }
        else if iCount == 5 {
//            let  output = self.image?.applySketchEffects(returnResult: RemoveBackroundResult.finalImage)
//            self.imageView?.image = output
        }
        else if iCount == 6 {
            let  output = self.image?.applyCartoonEffects(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }
        else if iCount == 7 {
            let  output = self.image?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }
        else {
            let  output = self.image?.removeBackground(returnResult: RemoveBackroundResult.finalImage)
            self.imageView?.image = output
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
            SwiftLoader.hide()
        }
    }
}


struct City {
    var image:String = ""
    var name:String = ""
    
    init(image: String, name: String){
        self.image = image
        self.name = name
    }
}
