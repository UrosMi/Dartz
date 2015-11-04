//
//  ScoreField.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/27/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class ScoreLabel: UILabel, NewGameResetProtocol {
    
    override var text: String? {
        willSet(newText) {
            if text != newText {
                animateScoreChange(withduration: 0.12, andJumpHeight: 5.2)
            }
        }
    
    }
    
    func animateScoreChange(withduration duration: Double, andJumpHeight jHeight: CGFloat) {
        UIView.animateWithDuration(duration*0.5,
            delay: 0.0,
            options: .CurveEaseIn,
            animations: { () -> Void in
                self.transform = CGAffineTransformMakeTranslation(0, -jHeight)
            },
            completion: { (done) -> Void in
                if done {
                    UIView.animateWithDuration(duration*0.5,
                        delay: 0.0,
                        options: .CurveEaseOut,
                        animations: { () -> Void in
                        self.transform = CGAffineTransformMakeTranslation(0, 0)
                        },
                        completion: { (done) -> Void in
                            
                    })
                }
            })
    }
    
    func resetToDefault() {
        text = "0"
    }
}
