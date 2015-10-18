//
//  InterfaceController.swift
//  DartzWatch Extension
//
//  Created by Uros Mihailovic on 10/18/15.
//  Copyright © 2015 me. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var session: WCSession!

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        }
        // Configure interface objects here.
        
    }

    @IBOutlet var score: WKInterfaceLabel!

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    // MARK: - WatchConnectivity callbacks
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let teamScore = message["teamScore"] as! Int
        score.setText("\(teamScore)")
    }

}
