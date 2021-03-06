//
//  MultiPlayerNetworking.swift
//  Dogde Ball
//
//  Created by Morten Stulen on 12.03.2018.
//  Copyright © 2018 Morten Stulen. All rights reserved.
//

import UIKit
import GameKit

protocol MultiplayerNetworkingProtocol: class {
    func matchEnded()
    func setCurrentPlayerIndex(index :Int)
    func movePlayerAtIndex(index: Int, movePercent: Float)
    func showGameOver(localPlayerWin: Bool?)
    func addRowFromRandomNumber(randomNumber: Int)
}

enum GameState : Int {
    case WaitingForMatch = 0
    case WaitingForRandomNumber
    case WaitingForStart
    case Active
    case Done
}

enum MessageType : Int {
    case RandomNumber = 0
    case GameBegin
    case Move
    case GameOver
    case Row
}

struct Message {
    var messageType: MessageType
}

struct MessageRandomNumber {
    var message: Message
    var randomNumber: UInt32
}

struct MessageGameBegin {
    var message: Message
}

struct MessageMove {
    var message: Message
    var movePercent: Float
}

struct MessageRow {
    var message: Message
    var randomNumber: Int
}

struct MessageGameOver {
    var message: Message
    var player1Won: Bool
}

struct Player {
    var playerIdKey: String
    var randomNumberKey: UInt32
}

class RandomNumberDetails: NSObject {
    let playerId: String
    let randomNumber: UInt32
    
    init(playerId: String, randomNumber: UInt32) {
        self.playerId = playerId
        self.randomNumber = randomNumber
        super.init()
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        let randomNumberDetails = object as? RandomNumberDetails
        return randomNumberDetails?.playerId == self.playerId
    }
    
}

class MultiPlayerNetworking: NSObject, GameKitHelperDelegate {
    
    var ourRandomNumber: UInt32
    var gameState: GameState
    var isPlayer1: Bool
    var receivedAllRandomNumbers: Bool
    var orderOfPlayers = [RandomNumberDetails]()
    
    weak var delegate: MultiplayerNetworkingProtocol?
    
    override init() {
        ourRandomNumber = arc4random()
        gameState = GameState.WaitingForMatch
        isPlayer1 = false
        receivedAllRandomNumbers = false
        orderOfPlayers = [RandomNumberDetails]()
        if let playerID = GKLocalPlayer.localPlayer().playerID {
            orderOfPlayers.append(RandomNumberDetails(playerId: playerID, randomNumber: ourRandomNumber))
        } else {
            print("Could not get playerID")
        }

        super.init()
        
    }
    
    
    func matchStarted() {
        print("Match has started successfully")
        if receivedAllRandomNumbers {
            gameState = GameState.WaitingForMatch
        } else {
            gameState = GameState.WaitingForRandomNumber
        }
        sendRandomNumber()
        tryStartGame()
        
    }
    
    func send(data: NSData) {
        let gameKitHelper = GameKitHelper.sharedGameKitHelper
        do {
            try gameKitHelper.match.sendData(toAllPlayers: data as Data, with: GKMatchSendDataMode.reliable)
        } catch let error {
            print("Error sending data:" + error.localizedDescription)
            matchEnded()
        }
    }
    
    func sendRandomNumber() {
        var message = MessageRandomNumber(message: Message(messageType: MessageType.RandomNumber), randomNumber: ourRandomNumber)
        let data = NSData(bytes: &message, length: MemoryLayout<MessageRandomNumber>.size)
        send(data: data)
        
    }
    
    func sendBeginGame() {
        var message = MessageGameBegin(message: Message(messageType:
            MessageType.GameBegin))
        let data = NSData(bytes: &message, length: MemoryLayout<MessageGameBegin>.size)
        send(data: data)
    }
    
    func tryStartGame() {
        if isPlayer1 && gameState == GameState.WaitingForStart {
            gameState = GameState.Active
            sendBeginGame()
            delegate?.setCurrentPlayerIndex(index: 0)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "start_multiplayer_game"), object: nil)
        }
    }
    
    func indexForLocalPlayer() -> Int? {
        if let playerID = GKLocalPlayer.localPlayer().playerID {
            return indexForPlayer(playerId: playerID)
        }
        return nil
    }
    
    func indexForPlayer(playerId: String) -> Int? {
        var idx: Int?
        for (index, playerDetail) in orderOfPlayers.enumerated() {
            let pId = playerDetail.playerId
            if pId == playerId {
                idx = index
                break
            }
        }
        return idx
    }
    
    
    func matchEnded() {
        print("match ended")
    }
    
    func allRandomNumbersAreReceived() -> Bool {
        var receivedRandomNumbers = Set<UInt32>()
        
        for playerDetail in orderOfPlayers {
            receivedRandomNumbers.insert(playerDetail.randomNumber)
        }
        
        if let multiplayerMatch = GameKitHelper.sharedGameKitHelper.match {
            if receivedRandomNumbers.count == multiplayerMatch.players.count + 1 {
                return true
            }
        }
        return false
    }
    
    func processReceivedRandomNumber(randomNumberDetails: RandomNumberDetails) {
        orderOfPlayers.append(randomNumberDetails)
        orderOfPlayers.sort(by: { $0.randomNumber < $1.randomNumber })

        if allRandomNumbersAreReceived() {
            receivedAllRandomNumbers = true
        } else {
            print("All random numbers are not recieved")
        }
        
    }
    func isLocalPlayerPlayer1() -> Bool {
        let playerDetail = orderOfPlayers[0]
        if playerDetail.playerId == GKLocalPlayer.localPlayer().playerID {
            print("I'm player 1")
            return true
        }
        print("I'm player 2")

        return false
    }
    
    func match(match: GKMatch, didReceive data: Data, fromPlayer playerID: String) {
        let message = data.withUnsafeBytes { (ptr: UnsafePointer<Message>) -> Message in
            return ptr.pointee
        }
        
        if message.messageType == MessageType.RandomNumber {
            let messageRandomNumber = data.withUnsafeBytes({ (ptr: UnsafePointer<MessageRandomNumber>) -> MessageRandomNumber in
                return ptr.pointee
            })
            print("Received random number:\(messageRandomNumber.randomNumber)")
            
            var tie = false
            if (messageRandomNumber.randomNumber == ourRandomNumber) {
                print("tie, you won the lottery")
                tie = true
                ourRandomNumber = arc4random()
                self.sendRandomNumber()
            } else {
                processReceivedRandomNumber(randomNumberDetails: RandomNumberDetails(playerId:
                    playerID, randomNumber: messageRandomNumber.randomNumber))
            }
            
            if receivedAllRandomNumbers {
                isPlayer1 = isLocalPlayerPlayer1()
            }
            
            if !tie && receivedAllRandomNumbers {
                //5
                if gameState == GameState.WaitingForRandomNumber {
                    gameState = GameState.WaitingForStart
                }
                tryStartGame()
            }
            
        } else if message.messageType == MessageType.GameBegin {
            gameState = GameState.Active
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "start_multiplayer_game"), object: nil)
            if let localPlayerIndex = indexForLocalPlayer() {
                delegate?.setCurrentPlayerIndex(index: localPlayerIndex)
            } else {
                print("Message active no localPlayerIndex")
            }
        } else if message.messageType == MessageType.Move {
            let messageMove = data.withUnsafeBytes({ (ptr: UnsafePointer<MessageMove>) -> MessageMove in
                return ptr.pointee
            })
            if let playerID = self.indexForPlayer(playerId: playerID) {
                self.delegate?.movePlayerAtIndex(index: playerID, movePercent: messageMove.movePercent)
            } else {
                print("Message move no playerID")
            }
        
        } else if message.messageType == MessageType.GameOver {
        
            let messageGameOver = data.withUnsafeBytes({ (ptr: UnsafePointer<MessageGameOver>) -> MessageGameOver in
                return ptr.pointee
            })

            if (messageGameOver.player1Won == true){
                delegate?.showGameOver(localPlayerWin: false)
            }else {
                delegate?.showGameOver(localPlayerWin: true)
            }
            
        } else if message.messageType == MessageType.Row {
            let messageRow = data.withUnsafeBytes({ (ptr: UnsafePointer<MessageRow>) -> MessageRow in
                return ptr.pointee
            })
            delegate?.addRowFromRandomNumber(randomNumber: messageRow.randomNumber)
        }
 
    }
    func sendMove(movePercent: Float) {
        var messageMove = MessageMove(message: Message(messageType: MessageType.Move), movePercent: movePercent)
        let data = NSData(bytes: &messageMove, length: MemoryLayout<MessageMove>.size)
        send(data: data)

    }
    
    func sendRow(randomNumber: Int) {
        var messageRow = MessageRow(message: Message(messageType: MessageType.Row), randomNumber: randomNumber)
        let data = NSData(bytes: &messageRow, length: MemoryLayout<MessageRow>.size)
        send(data: data)
    }
    
    func sendGameOver(player1won: Bool) {
        var gameOverMessage = MessageGameOver(message:
            Message(messageType: MessageType.GameOver), player1Won: player1won)
        let data = NSData(bytes: &gameOverMessage, length: MemoryLayout<MessageGameOver>.size)
        send(data: data)

    }
}
