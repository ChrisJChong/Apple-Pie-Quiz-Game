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
    var playerTotal = 0
    
    var totalWins = 0 {
        didSet {
            newGameButton.isEnabled = true
            newRound()
        }
    }
    
    var totalLosses = 0 {
        didSet {
            newGameButton.isEnabled = true
            newRound()
        }
    }
        
    @IBOutlet weak var guessWordTextField: UITextField!
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
        
        //Disable the textfield
        guessWordTextField.isEnabled = false
        
        //Initially disable buttons
        enableLetterButtons(false)
        
        //Let user know that they have to choose the number of players
        playerLabel.text = "Choose the number of players!"
        
    }
    
    //When
    @IBAction func newGamePressed(_ sender: UIButton) {
        //Clear player array
        players.removeAll()
        
        let index = numberOfPlayers.selectedSegmentIndex
        
        if let num = Int(numberOfPlayers.titleForSegment(at: index)!) {
            print("Number of players selected: \(num)")
            //Add the number of players based on the number of players selected in the UISegmentControl
            for i in 0...num-1 {
                players.append(Player(name: listOfPlayerNames[i]))
            }
            
            playerTotal = num
        }
        //print("\(numberOfPlayers.titleForSegment(at: index) ?? "")")
        
        //Create a new round
        newRound()
    }
    
    //Creates a new word for the game
    func newRound() {
        if !listOfWords.isEmpty {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters: [], points: totalPoints, players: playerTotal, currentPlayer: 1)
            enableLetterButtons(true)
            newGameButton.isEnabled = false
            guessWordTextField.isEnabled  = true
            numberOfPlayers.isEnabled = false
            updateUI()
            print("newRound")
        } else {
            enableLetterButtons(false)
            guessWordTextField.isEnabled  = false
            numberOfPlayers.isEnabled = true
            
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
        playerLabel.text = "Player: \(currentGame.currentPlayer)"
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses), Points: \(currentGame.points)"
        treeImageView.image = UIImage(named:"Tree \(currentGame.incorrectMovesRemaining)")
    }

    @IBAction func wordDidGuess(_ sender: UITextField) {
        
        if let guessedWord = sender.text {
            if currentGame.wordGuess(guessedWord) {
                
                totalWins += 1
                //print("Correct word guess")
                
                //Clear the text input
                sender.text = ""
            } else {
                //Clear the text input
                sender.text = ""
            }
        }
    }
    
}

