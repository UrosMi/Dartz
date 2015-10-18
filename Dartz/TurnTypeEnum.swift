//
//  TurnTypeEnum.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/17/15.
//  Copyright © 2015 me. All rights reserved.
//

import Foundation

enum TurnType : Int {
    case RegularTurn = 0,UndoneTurn,RedoneTurn
    
    static func turnTypeFromInt(int: Int) -> TurnType {
        switch int {
        case 0:
            return .RegularTurn
        case 1:
            return .UndoneTurn
        case 2:
            return .RedoneTurn
        default:
            return .RegularTurn
        }
    }
}