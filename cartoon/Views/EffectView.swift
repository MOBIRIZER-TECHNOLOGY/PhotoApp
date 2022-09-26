//
//  EffectView.swift
//  cartoon
//
//  Created by pawan kumar on 24/09/22.
//

import UIKit

class EffectView: UIView {
    
    var panGesture  = UIPanGestureRecognizer()
    var pinchGesture  = UIPinchGestureRecognizer()
    var bgImageView: UIImageView?
    var profileImageView: UIImageView?
    var fgImageView: UIImageView?

    override init(frame: CGRect){
        super.init(frame: frame)
        createSubViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        bgImageView?.frame = bounds
//        profileImageView?.frame = bounds
        fgImageView?.frame = bounds
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createSubViews()
    }
    
    private func createSubViews() {
        bgImageView =  UIImageView(frame: bounds)
        profileImageView =  UIImageView(frame: bounds)
        fgImageView =  UIImageView(frame: bounds)
        addSubview(bgImageView!)
        addSubview(profileImageView!)
        addSubview(fgImageView!)
        
        //pan gesture for dragging an image
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(EffectView.dragImg(_:)))
        profileImageView?.isUserInteractionEnabled = true
        profileImageView?.addGestureRecognizer(panGesture)
        
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(EffectView.scaleImg(_:)))
        profileImageView?.isUserInteractionEnabled = true
        profileImageView?.addGestureRecognizer(pinchGesture)
        
        NSLayoutConstraint.activate([
            //            bgImageView?.centerXAnchor.constraint(equalTo: centerYAnchor),
            //            bgImageView?.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    @objc func dragImg(_ sender:UIPanGestureRecognizer){
        if (sender.state == .changed) {
            let translation = sender.translation(in: self)
            profileImageView!.center = CGPoint(x: (profileImageView?.center.x)! + translation.x, y: (profileImageView?.center.y)! + translation.y)
            sender.setTranslation(CGPoint.zero, in: self)
        }
         else  if (sender.state == .ended ) {
             print("sender.dragImg:",profileImageView?.frame)
             print("profileImageView?.frame.midX:",profileImageView?.frame.midX)
         }
    }

    //Pinch Gesture for zoom in and zoom out
    @objc func scaleImg(_ sender: UIPinchGestureRecognizer) {
        print("sender.scale",sender.scale)
        profileImageView?.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    func screenshot() -> UIImage? {
        let containerView = self
        let containerSuperview = containerView.superview
        let renderer = UIGraphicsImageRenderer(bounds: containerView.frame)
        return renderer.image { (context) in
            containerSuperview?.layer.render(in: context.cgContext)
       }
  }
    
} // end MyView

