//
//  ViewController.swift
//  Concentration
//
//  Created by Vasanthakumar Annadurai on 30/08/22.
//

import UIKit

class ViewController: UIViewController {
    
    private let animalTheme = ["🦇", "🐅", "🐘", "🐈", "🐿"]
    
    private lazy var game = Concentration(noOfPairOfCards: self.noOfPairOfCards)
    var noOfPairOfCards: Int {
        return (cardButtons.count+1)
    }
    private lazy var emojiChoices = self.animalTheme
    private var emoji = [Int:String]()
    
    @IBOutlet weak private var scoreLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Concentration(noOfPairOfCards: (self.cardButtons.count+1)/2)
        emojiChoices = animalTheme
        emoji = [:]
        updateViewFromModel()
    }
    
    private func updateViewFromModel(){
        for index in cardButtons.indices{
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp{
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            }else{
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        
        scoreLabel.text = "Score: \(game.score)"
    }
    
    private func emoji(for card : Card) -> String{
        if emoji[card.identifier] == nil, emojiChoices.count > 0{
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }
        return emoji[card.identifier] ?? "?"
    }
}

extension Int{
    var arc4random: Int{
        if self>0{
            return Int(arc4random_uniform(UInt32(self)))
        }else if(self < 0){
            return Int(arc4random_uniform(UInt32(abs(self))))
        }else{
            return 0
        }
    }
}

