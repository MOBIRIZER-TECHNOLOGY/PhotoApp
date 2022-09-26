//
//  EffectViewCell.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

class EffectViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupUI(isSelected: Bool ) {
        super.layoutSubviews()
        if isSelected{
            self.setCornerRadiusWith(radius: 10, borderWidth: 2, borderColor: UIColor.orange)
        }
        else {
            self.setCornerRadiusWith(radius: 10, borderWidth: 2, borderColor: UIColor.gray)
        }
    }
}
