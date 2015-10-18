//
//  ViewController.swift
//  Dartz
//
//  Created by Uros Mihailovic on 9/29/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    let teamOne = 1337;
    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet var teamOneHits: [HitButton]!

    let teamTwo = 8005;
    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet var teamTwoHits: [HitButton]!

    var gameMaster = GameMaster()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUI:", name: "updateUI", object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func undoTapped(sender: UIButton) {
        gameMaster.undoTurn()
    }
    @IBAction func newGameTapped(sender: UIButton) {
        for hit in teamOneHits {hit.currentState = ButtonState.NoHits}
        for hit in teamTwoHits {hit.currentState = ButtonState.NoHits}
        teamOneLabel.text = "\(0)"
        teamTwoLabel.text = "\(0)"
        gameMaster.newGame()
    }
    
    @IBAction func hitTapped(sender: HitButton) {
        var scoreChange = sender.hitValue
        if sender.currentState.successor() != ButtonState.Closed {scoreChange = 0}
        gameMaster.makeTurn(sender.tag, scoreChange: scoreChange, hitValue: UInt(sender.hitValue), turnType: TurnType.RegularTurn)
    }

    dynamic private func updateUI(notification: NSNotification) {
        let infoDict = notification.userInfo!
        let id = infoDict["buttonID"] as! Int
        let turnTypeInt = infoDict["turnType"] as! Int
        let team = infoDict["team"] as! Int
        let shouldUpdateHits = infoDict["flag"] as! Bool
        
        updateScoreLabelForTeam(team)
        if shouldUpdateHits {updateHitButton(id, forTeam: team, turntype: TurnType.turnTypeFromInt(turnTypeInt))}
    }
    
    private func updateScoreLabelForTeam(teamNum: Int) {
        if teamNum == teamOne {
            teamOneLabel.text = "\(gameMaster.teamOneScore)"
        }
        else {
            teamTwoLabel.text = "\(gameMaster.teamTwoScore)"
        }
        
    }
    
    private func updateHitButton(buttonId: Int,forTeam team: Int,turntype type: TurnType) {
        let hitCollection = team == teamOne ? teamOneHits : teamTwoHits
        for hitButton in hitCollection {
            if buttonId == hitButton.hitValue  {
                hitButton.currentState = hitButton.currentState.nextStateFor(type)
            }
        }
    
    }
}

