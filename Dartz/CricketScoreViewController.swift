//
//  ViewController.swift
//  Dartz
//
//  Created by Uros Mihailovic on 9/29/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit

class CricketScoreViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var teamOneLabel: ScoreLabel!
    @IBOutlet var teamOneHits: [HitButton]!

    @IBOutlet weak var teamTwoLabel: ScoreLabel!
    @IBOutlet var teamTwoHits: [HitButton]!

    @IBOutlet weak var teamOneName: TeamNameField!
    @IBOutlet weak var teamTwoName: TeamNameField!
    var gameMaster = GameMaster()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teamOneName.delegate = self
        teamTwoName.delegate = self
        let dismissTap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(dismissTap)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "updateUI:", name: GlobalConsts.kUpdateUINotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: - Outlet actions
    @IBAction func undoTapped(sender: UIButton) {
        gameMaster.undoTurn()
    }
    @IBAction func newGameTapped(sender: UIButton) {
        for hit in teamOneHits { hit.resetToDefault() }
        for hit in teamTwoHits { hit.resetToDefault() }
        teamOneLabel.resetToDefault()
        teamTwoLabel.resetToDefault()
        teamOneName.resetToDefault()
        teamTwoName.resetToDefault()
        
        gameMaster.newGame()
    }
    
    @IBAction func hitTapped(sender: HitButton) {
        var scoreChange = sender.hitValue
        if let teamID = teamIDFor(sender) {
            if hitWithID(sender.hitValue, closedForTeam: teamID) && sender.currentState.successor() == ButtonState.Closed {
                sender.currentState = ButtonState.Closed
                return
            }
            if sender.currentState.successor() != ButtonState.Closed {scoreChange = 0}
            gameMaster.makeTurn(teamID, scoreChange: scoreChange, hitValue: UInt(sender.hitValue), turnType: TurnType.RegularTurn)
       

        }
        else {
            print("ERROR: One of the buttons is not in any collection(team)")
        }
        view.endEditing(true)
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
    
    private func updateHitButton(buttonId: Int, forTeam team: UInt,turntype type: TurnType) {
        let hitCollection = hitCollectionForTeam(TeamID(rawValue: team)!)
        let hitButton = hitButtonWithID(buttonId, inCollection: hitCollection)
        if let hitButton = hitButton {
            hitButton.currentState = hitButton.currentState.nextStateFor(type)
        }
        else {
            print("ERROR: Button \(hitButton) is not in any collection",hitButton)
        }
    }
    
    // MARK: - Utils
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
    
    private func hitButtonWithID(buttonID: Int, inCollection hitCollection: [HitButton]) -> HitButton? {
        for hitButton in hitCollection {
            if buttonID == hitButton.hitValue  {
                return hitButton
            }
        }
        return nil
    }
    
    private func hitWithID(buttonID: Int, closedForTeam team: TeamID) -> Bool {
        let opposingTeamHits = hitCollectionForTeam(team.oppositeTeam())
        if let opposingTeamHit = hitButtonWithID(buttonID, inCollection: opposingTeamHits) {
            return [ButtonState.ThreeHits,ButtonState.Closed].contains(opposingTeamHit.currentState) ? true : false
        }
        else {
            print("ERROR: One of the buttons is not in any collection(team)")
            return false
        }
    }
    
    private func hitCollectionForTeam(team: TeamID) -> [HitButton] {
        return team == TeamID.TeamOne ? teamOneHits : teamTwoHits
    }
    
    // MARK: - Text Field Delegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let teamNameField = textField as? TeamNameField{
            teamNameField.tryRevertingToDefaultTeamName()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let teamNameField = textField as? TeamNameField{
            teamNameField.tryRevertingToDefaultTeamName()
        }
        textField.endEditing(true)
        return true;
    }
    
}

