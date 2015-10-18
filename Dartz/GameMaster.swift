//
//  GameMaster.swift
//  Dartz
//
//  Created by Uros Mihailovic on 10/16/15.
//  Copyright © 2015 me. All rights reserved.
//

import UIKit
import WatchConnectivity

class GameMaster: NSObject, WCSessionDelegate {
    
    struct GameTurn {
        var teamNum : Int
        var scoreChange : Int
        var buttonID : UInt
        var turnType : TurnType
        init(fromTeam team: Int, valueChange: Int, hitValue: UInt, andType ttype: TurnType) {
            teamNum = team
            scoreChange = valueChange
            buttonID = hitValue
            turnType = ttype
        }
    }

    let teamOne = 1337;
    let teamTwo = 8005;
    var turnStack = Array<GameTurn>()
    var teamOneScore = 0
    var teamTwoScore = 0
    var session: WCSession?
    
    override init() {
        super.init()
        setupWatchSession()
    }
    
    func makeTurn(team: Int, scoreChange: Int, hitValue: UInt, turnType: TurnType) {
        let turn = GameTurn(fromTeam: team, valueChange: scoreChange, hitValue: hitValue, andType: turnType)
        updateScore(turn)
        turnStack.append(turn)
        notifyForUIUpdate(turn, shouldUpdateHits: true);
        printStack()
    }
    func undoTurn() {
        guard let lastTurn = turnStack.popLast() else {return}
        let undoingTurn = GameTurn(fromTeam: lastTurn.teamNum, valueChange: -lastTurn.scoreChange, hitValue: lastTurn.buttonID, andType: TurnType.UndoneTurn)
        updateScore(undoingTurn)
        var shouldUpateHits = false
        if undoingTurn.turnType == TurnType.UndoneTurn && undoingTurn.scoreChange == 0 {
            shouldUpateHits = true
        }
        notifyForUIUpdate(undoingTurn, shouldUpdateHits: shouldUpateHits)
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
        if (turnChanges.teamNum == teamOne) {
            teamOneScore += turnChanges.scoreChange
        }
        else {
            teamTwoScore += turnChanges.scoreChange
        }
    }
    func notifyForUIUpdate(turnState: GameTurn) {
        NSNotificationCenter.defaultCenter().postNotificationName("updateUI",
            object: self,
            userInfo: ["team": turnState.teamNum,
                   "turnType": turnState.turnType.rawValue,
                   "buttonID": turnState.buttonID])
    }
    func notifyForUIUpdate(turnState: GameTurn, shouldUpdateHits: Bool) {
        
        let infoDict : [String:AnyObject] = ["team": turnState.teamNum,
                    "turnType": turnState.turnType.rawValue,
                    "buttonID": turnState.buttonID,
                        "flag": shouldUpdateHits]
        
        if session != nil && session!.reachable {
            session!.sendMessage(["teamScore":teamOneScore], replyHandler: nil, errorHandler: nil)
        }
        NSNotificationCenter.defaultCenter().postNotificationName("updateUI",
            object: self,
            userInfo:infoDict)
    }
    
    private func printStack() {
        for turn in turnStack {
            print("[\(turn.scoreChange),\(turn.buttonID),\(turn.turnType)]")
        }
        print("______________________________")
    }
}
