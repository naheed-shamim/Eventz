//
//  EventzActivityIndicator.swift
//  Eventz
//
//  Created by Naheed Shamim on 31/08/17.
//  Copyright © 2017 Naheed Shamim. All rights reserved.
//

import UIKit

class EventzActivityIndicator: UIView {
    
    static let sharedInstance = EventzActivityIndicator()
    
    let activityIndicator : UIActivityIndicatorView
    let indicatorView : UIView
    let indicatorLabel : UILabel
    
    private init()
    {
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorLabel = UILabel(frame: CGRect(x: Constants.kScreenWidth/2, y: Constants.kScreenHeight/2, width: 100, height: 20))
        indicatorView = UIView(frame: CGRect(x: Constants.kScreenWidth/2, y: Constants.kScreenHeight/2, width: 100, height: 100))
        
        super.init(frame: CGRect(x: 0, y: 0, width: Constants.kScreenWidth, height: Constants.kScreenHeight))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func showIndicatorOn(vc: UIViewController)
    {
        self.backgroundColor = UIColor.black
        self.alpha = 0.7
        self.center = CGPoint(x:vc.view.center.x,y:vc.view.center.y)
        
        self.indicatorView.backgroundColor = UIColor(red: 45/255, green: 103/255, blue: 196/255, alpha: 1.0)
        self.indicatorView.alpha =  1
        self.indicatorView.center = CGPoint(x:self.center.x,y:self.center.y+10)
        self.indicatorView.layer.cornerRadius = 8
        
        self.indicatorLabel.textColor = UIColor.white
        self.indicatorLabel.center = CGPoint(x:self.center.x,y:self.center.y+30) // change this
        self.indicatorLabel.text = "Loading"
        self.indicatorLabel.textAlignment = .center
        
        self.activityIndicator.center = vc.view.center
        self.activityIndicator.startAnimating()
        
        self.addSubview(indicatorView)
        self.addSubview(indicatorLabel)
        self.addSubview(activityIndicator)
        
//        self.showZoomAnimation()
        
        vc.view.addSubview(self)
    }
    
    
    
    func hideIndicator()
    {
        self.removeFromSuperview()
    }
}


