//
//  ViewController.swift
//  Guided Project - Apple Pie
//
//  Created by wade chen on 29/6/20.
//  Copyright © 2020 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var totalPoints = 0
    var currentGame: Game!
    let incorrectMovesAllowed = 7
    var listOfWords = ["buccaneer","swift","glorious","incandescent","bug","program"]
    
    var listOfPlayerNames = ["Bob","Susan","Lily","Ben"]
    
    var players : [Player] = []
    
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
        
    @IBOutlet weak var newGameButton: UIButton!
    @IBOutlet weak var numberOfPlayers: UISegmentedControl!
    @IBOutlet weak var playerLabel: UILabel!
    
    @IBOutlet weak var treeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        
        //Default to Player 1 - Always assume there is at least one player at the moment
        //currentGame//Player(id: <#T##Int#>, name: <#T##String#>)
        
        //Initially disable buttons
        enableLetterButtons(false)
        
        //Let user know that they have to choose the number of players
        playerLabel.text = "Choose the number of players!"
        
    }
    
    //When
    @IBAction func newGamePressed(_ sender: UIButton) {
        let index = numberOfPlayers.selectedSegmentIndex
        
        if let num = Int(numberOfPlayers.titleForSegment(at: index)!) {
            print("Number of players selected: \(num)")
            //Add the number of players based on the number of players selected in the UISegmentControl
            for i in 1...num {
                players.append(Player(name: listOfPlayerNames[i]))
            }
            print("\(players)")
            print("\(players.count)")
            
        }
        //print("\(numberOfPlayers.titleForSegment(at: index) ?? "")")
        
        //Create a new round
        //newRound()
        
    }
    
    
    //Creates a new word for the game
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [], points: totalPoints, playerID: 1)
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

