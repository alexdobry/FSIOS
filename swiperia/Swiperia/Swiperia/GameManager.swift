//
//  SingleMultiManager.swift
//  Swiperia
//
//  Created by Edgar Gellert on 23.08.17.
//  Copyright © 2017 Dedy Gubbert. All rights reserved.
//

import Foundation

struct Game {
    let name : String
    let imageName : String
    let description : String
    let gameType : String
    
    init(gameName : String, imageName : String, gameType : String, description : String) {
        self.name = gameName
        self.imageName = imageName
        self.gameType = gameType
        self.description = description
    }
}

struct GameManager {
    let gameModes : [String : Game] = [
        //MARK: MultiPlayerGameMode: giantWars
        "giantWars" : Game(
            gameName: "giantWars",
            imageName: "giantWars",
            gameType: GameMode.multi.rawValue,
            description: "Let your giant fight your opponent. Play with your friend, earn items and hurl them aiganst your enemy to excaerbate his proceed."),
        
        //MARK: SinglePlayerGameMode: beatTheMachine
        "beatTheMachine" : Game(
            gameName: "beatTheMachine",
            imageName: "beatTheMachine",
            gameType: GameMode.single.rawValue,
            description: "Fight against the computer, chase the highscore and defy the obstacles of the machine."),
        
        //Mark: MultiPlayerGameMode: sequenceBreaker
        "sequenceBreaker" : Game(
            gameName: "sequenceBreaker",
            imageName: "sequenceBreaker",
            gameType: GameMode.multi.rawValue,
            description: "Play a session with your friend. Indicate directions alternately and remember the sequence. The first one who fail loses the game."),
        
        //MARK: MultiPlayerGameMode: testGameMode
        "testGameMode1" : Game(
            gameName: "testGameMode1",
            imageName: "testGameMode1",
            gameType: GameMode.multi.rawValue,
            description: "Play a session with your friend. Indicate directions alternately and remember the sequence. The first one who fail loses the game."),
        //MARK: MultiPlayerGameMode: testGameMode
        "testGameMode2" : Game(
            gameName: "testGameMode2",
            imageName: "testGameMode2",
            gameType: GameMode.multi.rawValue,
            description: "Play a session with your friend. Indicate directions alternately and remember the sequence. The first one who fail loses the game."),
        //MARK: MultiPlayerGameMode: testGameMode
        "testGameMode3" : Game(
            gameName: "testGameMode3",
            imageName: "testGameMode3",
            gameType: GameMode.multi.rawValue,
            description: "Play a session with your friend. Indicate directions alternately and remember the sequence. The first one who fail loses the game.")
    
    ]
    
    
    func getSpecificGameModes(for gameType : GameMode) -> [Game] {
        return gameModes.filter{$1.gameType == gameType.rawValue}.map{$1}
    }
    
}
