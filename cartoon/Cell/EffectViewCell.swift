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
        // Initialization code
    }

    func setupUI(isSelected: Bool ) {
        super.layoutSubviews()
        if isSelected{
            self.frameImageView.image = UIImage(named: "Frame_btn_sel")
//            self.setCornerRadiusWith(radius: 10, borderWidth: 2, borderColor: UIColor.orange)
        }
        else {
            self.frameImageView.image = UIImage(named: "Frame_btn_unsel")
//            self.setCornerRadiusWith(radius: 10, borderWidth: 2, borderColor: UIColor.gray)
        }
    }
}
