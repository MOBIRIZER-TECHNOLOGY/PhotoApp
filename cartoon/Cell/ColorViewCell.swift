//
//  ColorViewCell.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

class ColorViewCell: BaseCollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var checkInimageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupUI(isSelected: Bool ) {
        super.layoutSubviews()
        self.setCornerRadiusWith(radius: 10, borderWidth: 2, borderColor: UIColor.clear)
        checkInimageView.isHidden = !isSelected
    }
}
