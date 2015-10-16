//
//  ButtonStateEnum.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/4/15.
//  Copyright © 2015 me. All rights reserved.
//

import Foundation

enum ButtonState : String {
    case NoHits = "_ _ _", OneHit = "O _ _", TwoHits = "O O _", ThreeHits = "O O O", Closed = "O O O +"
    
    func successor () -> ButtonState {
        switch (self) {
        case .NoHits:
            return .OneHit
        case .OneHit:
            return .TwoHits
        case .TwoHits:
            return .ThreeHits
        case .ThreeHits:
            return .Closed
        case .Closed:
            return .Closed
        }
        
    }
}