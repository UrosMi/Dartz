//
//  TeamNameField.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/27/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class TeamNameField: UITextField, NewGameResetProtocol {

    @IBInspectable var defaultTeamName : String = "Team One"
    
    func tryRevertingToDefaultTeamName() {
        if let text = self.text {
            if text.isEmpty {
                self.text = defaultTeamName
            }
        }
    }
    
    func resetToDefault() {
        text = defaultTeamName
    }

}
