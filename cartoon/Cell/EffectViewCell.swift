//
//  EffectViewCell.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

class EffectViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var frameImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        frameImageView.tintColor =  UIColor.clear
    }

    func setupUI(isSelected: Bool ) {
        super.layoutSubviews()
        if isSelected{
            self.frameImageView.image = UIImage(named: "Frame_btn_sel")
        }
        else {
            self.frameImageView.image = UIImage(named: "Frame_btn_unsel")
        }
    }
}
