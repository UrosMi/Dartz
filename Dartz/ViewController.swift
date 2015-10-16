//
//  ViewController.swift
//  Dartz
//
//  Created by Uros Mihailovic on 9/29/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var teamOneLabel: UILabel!
    let teamOne = 1337;
    @IBOutlet weak var teamTwoLabel: UILabel!
    let teamTwo = 8005;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func hitTapped(sender: HitButton) {

        let nextState = sender.currentState.successor()
        sender.currentState = nextState
        if nextState == ButtonState.Closed {
            if sender.tag == teamOne {
                let newScore = Int(teamOneLabel.text!)! + sender.hitValue
                teamOneLabel.text = "\(newScore)"
            } else {
                let newScore = Int(teamTwoLabel.text!)! + sender.hitValue
                teamTwoLabel.text = "\(newScore)"
            }
        }
        print("Hit value \(sender.hitValue)")
    }

}

