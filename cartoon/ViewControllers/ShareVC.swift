//
//  ShareVC.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

class ShareVC: BaseVC {
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var getHighQltyBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomView.roundCorners([.topLeft, .topRight], radius: 10.0 )
        getHighQltyBtn.layer.cornerRadius = getHighQltyBtn.frame.height / 2
        //getHighQltyBtn.isHidden = true
    }
    
    @IBAction func homeButtonAction(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func removeWatermarkAction(_ sender: Any) {
    }
    
    
    @IBAction func getHighQualityAction(_ sender: UIButton) {
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
    }
    
    
    @IBAction func whatsupAction(_ sender: UIButton) {
    }
    
    @IBAction func fbAction(_ sender: UIButton) {
    }
    
    @IBAction func instaAction(_ sender: UIButton) {
    }
    
    @IBAction func linkedAction(_ sender: UIButton) {
    }
    
    
    
}
