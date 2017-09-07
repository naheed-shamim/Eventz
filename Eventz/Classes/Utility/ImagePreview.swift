//
//  ImagePreview.swift
//  Eventz
//
//  Created by Naheed Shamim on 05/09/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit

class ImagePreview: UIView {

    static let sharedInstance = ImagePreview()
    
    var previewImage : UIImageView
    
    private init()
    {
        previewImage = UIImageView(frame: CGRect(x: 5, y: 5, width: Constants.kScreenWidth-50, height: Constants.kScreenWidth-50))
        super.init(frame: CGRect(x: 0, y: 0, width: Constants.kScreenWidth-40, height: Constants.kScreenWidth-40))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showImage(image:UIImage, vc:UIViewController)
    {
        self.backgroundColor = UIColor.black
        self.center = CGPoint(x:vc.view.center.x,y:vc.view.center.y)
        
        self.previewImage.image = image
        self.addSubview(self.previewImage)
        
        Utility.showWithZoomAnim(view: self)
        
        vc.view.addSubview(self)
    }
    
    func hideImagePreview()
    {
//        Utility.hideWithZoomAnim(view: self, completion: self.removeFromSuperview())
        
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            self.removeFromSuperview()
        })
        
    }
}
