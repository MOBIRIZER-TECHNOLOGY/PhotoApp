//
//  EffectsCollectionViewCell.swift
//  Cities
//
//  Created by Yasar on 29.01.2021.
//

import UIKit

class BaseStylizedCollectionViewCell: UICollectionViewCell {
    var cornerRadius: CGFloat = 5.0

    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.contentView.layer.cornerRadius = 2.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Improve scrolling performance with an explicit shadowPath
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
}


class EffectsCollectionViewCell: BaseStylizedCollectionViewCell {
    @IBOutlet weak var effectImageViewFirst: UIImageView!
    @IBOutlet weak var effectImageViewSecond: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tryButton: UIButton!
}



class EffectBgCollectionViewCell: BaseStylizedCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
}


