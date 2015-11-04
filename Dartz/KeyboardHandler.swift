//
//  CricketScoreKeyboardHandler.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/26/15.
//  Copyright © 2015 me. All rights reserved.
//

import Foundation
import UIKit

extension CricketScoreViewController {
    
    func keyboardWillShow(notification: NSNotification) {
        if self.view.bounds.origin.y != 0.0 { return }
        
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.bounds.origin.y += keyboardFrame.size.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info  = notification.userInfo!
        let value: AnyObject = info[UIKeyboardFrameEndUserInfoKey]!
        
        let rawFrame = value.CGRectValue
        let keyboardFrame = view.convertRect(rawFrame, fromView: nil)
        
        UIView.animateWithDuration(0.3) { () -> Void in
            self.view.bounds.origin.y -= keyboardFrame.size.height
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
}