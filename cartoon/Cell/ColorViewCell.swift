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
    var isViewSelected = false
    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    func setupUI(isSelected: Bool ) {
        super.layoutSubviews()
        self.isViewSelected = isSelected
        updateUI()
    }
    
    func updateUI() {
        checkInimageView.isHidden = true
//        if self.isViewSelected {
//            self.contentView.backgroundColor = .orange
//            self.contentView.setCornerRadiusWith(radius: Float(self.contentView.frame.size.height) / 2, borderWidth: 2, borderColor: UIColor.red)
//        }
//        else {
//            self.contentView.backgroundColor = .gray
//            self.contentView.setCornerRadiusWith(radius: Float(self.contentView.frame.size.height) / 2, borderWidth: 2, borderColor: UIColor.clear)
//        }
    }
}
