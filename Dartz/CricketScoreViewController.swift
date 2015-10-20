//
//  ViewController.swift
//  Dartz
//
//  Created by Uros Mihailovic on 9/29/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class CricketScoreViewController: UIViewController{

    @IBOutlet weak var teamOneLabel: UILabel!
    @IBOutlet var teamOneHits: [HitButton]!

    @IBOutlet weak var teamTwoLabel: UILabel!
    @IBOutlet var teamTwoHits: [HitButton]!
    @IBOutlet weak var undoButton: UIButton!

    var gameMaster = GameMaster()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUI:", name: GlobalConsts.kUpdateUINotification, object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: - Outlet actions
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
        if let teamID = teamIDFor(sender) {
            if sender.currentState.successor() != ButtonState.Closed {scoreChange = 0}
            gameMaster.makeTurn(teamID, scoreChange: scoreChange, hitValue: UInt(sender.hitValue), turnType: TurnType.RegularTurn)
        }
        else {
            print("ERROR: One of the buttons is not in any collection(team)")
        }
    }
    
    // MARK: - UI updates
    dynamic private func updateUI(notification: NSNotification) {
        let infoDict = notification.userInfo!
        let id = infoDict[GlobalConsts.kButtonIDKey] as! Int
        let turnTypeInt = infoDict[GlobalConsts.kTurnTypeKey] as! Int
        let team = infoDict[GlobalConsts.kTeamIDKey] as! UInt
        let shouldUpdateHits = infoDict[GlobalConsts.kUIUpdateKey] as! Bool
        
        updateScoreLabelForTeam(team)
        if shouldUpdateHits {
            updateHitButton(id, forTeam: team, turntype: TurnType(rawValue: turnTypeInt)!)
        }
    }
    
    private func updateScoreLabelForTeam(teamNum: UInt) {
        if TeamID(rawValue: teamNum) == TeamID.TeamOne {
            teamOneLabel.text = "\(gameMaster.teamOneScore)"
        }
        else {
            teamTwoLabel.text = "\(gameMaster.teamTwoScore)"
        }
        
    }
    
    private func updateHitButton(buttonId: Int,forTeam team: UInt,turntype type: TurnType) {
        let hitCollection = TeamID(rawValue: team) == TeamID.TeamOne ? teamOneHits : teamTwoHits
        for hitButton in hitCollection {
            if buttonId == hitButton.hitValue  {
                hitButton.currentState = hitButton.currentState.nextStateFor(type)
            }
        }
    
    }
    
    private func teamIDFor(sender: HitButton) -> TeamID? {
        if teamOneHits.contains(sender)  {
            return TeamID.TeamOne
        }
        else if teamTwoHits.contains(sender) {
            return TeamID.TeamTwo
        }
        else {
            return nil
        }
    }
}

