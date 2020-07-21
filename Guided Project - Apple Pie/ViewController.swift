//
//  ViewController.swift
//  Guided Project - Apple Pie
//
//  Created by wade chen on 29/6/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentGame: Game!
    let incorrectMovesAllowed = 7
    var listOfWords = ["buccaneer","swift","glorious","incandescent","bug","program"]
    
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
        
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Do any additional setup after loading the view.
        newRound()
    }
    
    var totalPoints = 0
    
    //Creates a new word for the game
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [], points: totalPoints)
            enableLetterButtons(true)
            updateUI()
            print("newRound")
        } else {
            enableLetterButtons(false)
        }
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        let letterString = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        
        updateGameState()
        //updateUI()
    }
    
    //Add scoring feature that awards points for each correct guess and additional points for each successful word completion
    
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        } else if currentGame.word == currentGame.formattedWord {
            totalPoints = currentGame.points + 10
            totalWins += 1
        } else {
            updateUI()
        }
    }
    
    func updateUI() {
        //var letters = [String]()
        
        //Concatenates the collection of string characters
        /*for letter in currentGame.formattedWord {
            letters.append(String(letter))
        }*/
        
        let letters = currentGame.formattedWord.map { String($0) }
        
        //Each letter in the array is joined togheter with a space
        let wordWithSpacing = letters.joined(separator: " ")
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses), Points: \(currentGame.points)"
        treeImageView.image = UIImage(named:"Tree \(currentGame.incorrectMovesRemaining)")
    }

    
}

