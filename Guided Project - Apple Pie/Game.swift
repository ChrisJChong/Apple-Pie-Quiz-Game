//
//  Game.swift
//  Guided Project - Apple Pie
//
//  Created by wade chen on 4/7/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import Foundation




struct Game {
    var word: String
    var incorrectMovesRemaining: Int
    var guessedLetters: [Character]
    var points: Int
    var playerID: Int

    mutating func playerGuessed(letter: Character) {
        guessedLetters.append(letter)
        if !word.contains(letter) {
            //Letter was guessed incorrectly
            incorrectMovesRemaining -= 1
        } else {
            //Letter was guessed correctly
            points += 1
        }
    }
    
    var formattedWord: String {
        var guessedWord = ""
        for letter in word {
            if guessedLetters.contains(letter) {
                guessedWord += "\(letter)"
            } else {
                guessedWord += "_"
            }
        }
        return guessedWord
    }
    
}
