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
    internal var currentState = ButtonState.NoHits {
        didSet{
            setTitle(currentState.rawValue, forState: UIControlState.Normal)
        }
    }
  

}
