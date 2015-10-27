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
    
    let radius : CGFloat = 20.0
    let spacing : CGFloat = 4.0
    let visable : Float = 1.0
    let faded : Float = 0.15
    
    private var firstCircleLayer = CAShapeLayer()
    private var secondCircleLayer = CAShapeLayer()
    private var thirdCircleLayer = CAShapeLayer()
    
    
    var currentState = ButtonState.NoHits {
        didSet {
            switch currentState {
            case .NoHits:
                firstCircleLayer.opacity = faded
                secondCircleLayer.opacity = faded
                thirdCircleLayer.opacity = faded
            case .OneHit:
                firstCircleLayer.opacity = visable
                secondCircleLayer.opacity = faded
                thirdCircleLayer.opacity = faded
                break
            case .TwoHits:
                firstCircleLayer.opacity = visable
                secondCircleLayer.opacity = visable
                thirdCircleLayer.opacity = faded
                break
            case .ThreeHits,.Closed:
                firstCircleLayer.opacity = visable
                secondCircleLayer.opacity = visable
                thirdCircleLayer.opacity = visable
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
        circle.opacity = faded
        circle.shouldRasterize = true
        circle.rasterizationScale = UIScreen.mainScreen().scale
        return circle
    }

}
