//
//  HitButton.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/4/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class HitButton: UIButton {

    @IBInspectable var hitValue : Int = 0
    @IBInspectable var fillColor : UIColor = UIColor.whiteColor() 
    var radius : CGFloat = 20.0
    var spacing : CGFloat = 4.0
    
    private var firstCircleLayer = CAShapeLayer()
    private var secondCircleLayer = CAShapeLayer()
    private var thirdCircleLayer = CAShapeLayer()
    
    
    internal var currentState = ButtonState.NoHits {
        didSet{
            switch currentState {
            case .OneHit:
                firstCircleLayer.opacity = 1.0
                break
            case .TwoHits:
                secondCircleLayer.opacity = 1.0
                break
            case .ThreeHits:
                thirdCircleLayer.opacity = 1.0
                break
            default:
                break
            }
        }
    }
    
    override func setTitle(title: String?, forState state: UIControlState) {
        return
    }
    
    override func drawRect(rect: CGRect) {
     
        firstCircleLayer = createCircleLayerWithRadius(radius)
        firstCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds) - (radius + spacing), CGRectGetMidY(self.bounds))
        self.layer.insertSublayer(firstCircleLayer, atIndex: 0)
        
        secondCircleLayer = createCircleLayerWithRadius(radius)
        secondCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
        self.layer.insertSublayer(secondCircleLayer, atIndex: 0)
        
        thirdCircleLayer = createCircleLayerWithRadius(radius)
        thirdCircleLayer.position = CGPointMake(CGRectGetMidX(self.bounds) + (radius + spacing), CGRectGetMidY(self.bounds))
        self.layer.insertSublayer(thirdCircleLayer, atIndex: 0)
        
    }
    
    private func createCircleLayerWithRadius(radius:CGFloat) -> CAShapeLayer {
        let circle = CAShapeLayer()
        circle.frame = CGRectMake(0, 0, radius, radius)
        let bezierPath = UIBezierPath(ovalInRect:circle.bounds)
        circle.path = bezierPath.CGPath
        circle.fillColor = fillColor.CGColor
        circle.opacity = 0.1
        circle.shouldRasterize = true
        circle.rasterizationScale = UIScreen.mainScreen().scale
        return circle
    }

}
