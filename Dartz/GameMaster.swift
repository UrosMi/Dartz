//
//  GameMaster.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/16/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit
import WatchConnectivity

struct GameTurn {
    var teamNum : TeamID
    var scoreChange : Int
    var buttonID : UInt
    var turnType : TurnType
    func toDict(shouldUpdateHits: Bool) -> [String:AnyObject] {
        let dict: [String:AnyObject] =
            [GlobalConsts.kTeamIDKey: teamNum.rawValue,
            GlobalConsts.kTurnTypeKey: turnType.rawValue,
            GlobalConsts.kButtonIDKey: buttonID,
            GlobalConsts.kUIUpdateKey: shouldUpdateHits]
        return dict
    }
}

class GameMaster: NSObject, WCSessionDelegate {

    var turnStack = Array<GameTurn>()
    var teamOneScore = 0
    var teamTwoScore = 0
    var session: WCSession?
    
    override init() {
        super.init()
        setupWatchSession()
    }
    
    func makeTurn(team: TeamID, scoreChange: Int, hitValue: UInt, turnType: TurnType) {
        let turn = GameTurn(teamNum: team, scoreChange: scoreChange, buttonID: hitValue, turnType: turnType)
        updateScore(turn)
        turnStack.append(turn)
        notifyForUIUpdate(turn, shouldUpdateHits: true);
        printStack()
    }
    func undoTurn() {
        var turnToUndo = turnStack.popLast()
        if turnToUndo == nil {return}
        turnToUndo?.scoreChange = -turnToUndo!.scoreChange
        turnToUndo?.turnType = TurnType.UndoneTurn
        
        updateScore(turnToUndo!)
        var shouldUpateHits = false
        if turnToUndo!.turnType == TurnType.UndoneTurn && turnToUndo!.scoreChange == 0 {
            shouldUpateHits = true
        }
        notifyForUIUpdate(turnToUndo!, shouldUpdateHits: shouldUpateHits)
        printStack()
    }
    func newGame() {
        turnStack.removeAll()
        teamOneScore = 0
        teamTwoScore = 0
    }
    
    func setupWatchSession() {
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session!.delegate = self
            session!.activateSession()
        }
    }
    
    func updateScore(turnChanges: GameTurn) {
        if (turnChanges.teamNum == TeamID.TeamOne) {
            teamOneScore += turnChanges.scoreChange
        }
        else {
            teamTwoScore += turnChanges.scoreChange
        }
    }

    func notifyForUIUpdate(turnState: GameTurn, shouldUpdateHits: Bool) {
        
        let infoDict = turnState.toDict(shouldUpdateHits)
        
        if session != nil && session!.reachable {
            session!.sendMessage(["teamScore":teamOneScore], replyHandler: nil, errorHandler: nil)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(GlobalConsts.kUpdateUINotification,
            object: self,
            userInfo:infoDict)
    }
    
    private func printStack() {
        for turn in turnStack {
            print("[\(turn.teamNum),\(turn.scoreChange),\(turn.buttonID),\(turn.turnType)]")
        }
        print("----------------------------------------")
    }
}
