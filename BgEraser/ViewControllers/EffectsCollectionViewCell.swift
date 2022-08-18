//
//  EffectsCollectionViewCell.swift
//  Cities
//
//  Created by Yasar on 29.01.2021.
//

import UIKit

class EffectsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cityImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
}

struct Effects {
    var image:String = ""
    var name:String = ""
    
    init(image: String, name: String){
        self.image = image
        self.name = name
    }
}


