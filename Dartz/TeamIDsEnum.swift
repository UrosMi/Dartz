//
//  TeamIDsEnum.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/20/15.
//  Copyright © 2015 me. All rights reserved.
//

import Foundation

enum TeamID : UInt {
    case TeamOne = 1, TeamTwo = 2
    func oppositeTeam() -> TeamID {
        return self == .TeamOne ? .TeamTwo : .TeamOne
    }
}