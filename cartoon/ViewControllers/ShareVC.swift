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
    @IBOutlet weak var effectView:UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bottomView.roundCorners([.topLeft, .topRight], radius: 10.0 )
        getHighQltyBtn.layer.cornerRadius = getHighQltyBtn.frame.height / 2
        //getHighQltyBtn.isHidden = true
        self.effectView?.image  = Router.shared.outPutImage
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
    
    @IBAction func shareAction(_ sender: UIButton) {
        guard (Router.shared.outPutImage != nil) else {
            return
        }
        // set up activity view controller
        let imageToShare =  [Router.shared.outPutImage] // [ self.effectView?.bgImageView?.image ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
     
}

