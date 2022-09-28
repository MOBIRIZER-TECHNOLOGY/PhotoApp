//
//  GoProDetailCell.swift
//  cartoon
//
//  Created by Narender Kumar on 27/09/22.
//

import UIKit

protocol GoProDetailCellDelegate {
    func selectedGoProPlanitem(_ idx: Int)
}

class GoProDetailCell: UITableViewCell {
    
    @IBOutlet weak var mostpopularLbl: UILabel!
    @IBOutlet var goProScriptionViews: [GoProScriptionView]! {
        didSet {
            goProScriptionViews.forEach { scriptionView in
                scriptionView.delegate = self
                scriptionView.layer.cornerRadius = 15.0
                scriptionView.layer.masksToBounds = true
                scriptionView.layer.borderWidth = 2
                scriptionView.layer.borderColor = UIColor.gray.cgColor
                if scriptionView.isSelect {
                    //scriptionView.backgroundColor =  UIColor.systemPink
                } else {
                    //scriptionView.backgroundColor =  UIColor.orange
                }
            }
        }
    }
    var delegate: GoProDetailCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}


extension GoProDetailCell: GoProScriptionViewDelegate {
    
    func viewTapAction(_ sender: GoProScriptionView) {
        delegate?.selectedGoProPlanitem(sender.tag)
        
        goProScriptionViews.forEach { scriptionView in
            if sender == scriptionView {
                scriptionView.isSelect = true
                scriptionView.layer.borderColor = mostpopularLbl.backgroundColor?.cgColor
            } else {
                scriptionView.isSelect = false
                scriptionView.layer.borderColor = UIColor.gray.cgColor
            }
        }
    }
}



/// ********************* convert view  to button ****************** ///

protocol GoProScriptionViewDelegate {
    func viewTapAction(_ sender: GoProScriptionView)
}

class GoProScriptionView: UIView {
    
    var isSelect: Bool = false
    let nibName = "GoProScriptionView"
    var delegate: GoProScriptionViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupInit() {
//        guard let view = loadViewFromNib() else {
//            return
//        }
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    public func selectedView(_ isSelect: Bool) {
        self.isSelect = isSelect
    }
    
    @objc private func tapAction() {
        print("View tab action: ", self)
        delegate?.viewTapAction(self)
    }
    
}
