//
//  Concentration.swift
//  Concentration
//
//  Created by Vasanthakumar Annadurai on 30/08/22.
//

import Foundation

class Concentration{
    
    private(set) var cards = [Card]()
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get{
            var foundIndex: Int?
            for index in cards.indices{
                if cards[index].isFaceUp{
                    if foundIndex == nil{
                        foundIndex = index
                    }else{
                        return nil
                    }
                }
            }
            return foundIndex
        }set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    private(set) var noOfFilips = 0
    private(set) var score = 0
    private var previouslySeenCards = [Int]()
    
    init(noOfPairOfCards: Int) {
        assert(noOfPairOfCards>0, "Concentration.init(\(noOfPairOfCards): you must have atleast one pair of cards ")
        
        for _ in 0..<noOfPairOfCards{
            let card = Card()
            cards += [card, card] // Struct is a value type, hence it will be copied.
        }
        
        suffleCards() // Suffle cards.
    }
    
    // Suffle the cards.
    private func suffleCards(){
        var temp = [Card]()
        for _ in cards{
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            temp.append(cards.remove(at: randomIndex))
        }
        cards = temp
    }
    
    func chooseCard(at index: Int){
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index):  chosen index is not in the cards")
        
        if !cards[index].isMatched{
            noOfFilips += 1
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                // One card is already faceUp & second card has been choosed.
                if cards[matchIndex].identifier == cards[index].identifier{
                    // Matched.
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    
                    score += 2
                }else{
                    // Not Matched.
                    if(previouslySeenCards.contains(cards[matchIndex].identifier)){
                        score -= 1
                    }
                    if(previouslySeenCards.contains(cards[index].identifier)){
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
                
                addCardsToPreviouslySeenCards(first: cards[matchIndex], second: cards[index])
            }else{
                // either no card or two card is already faceup.
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    private func addCardsToPreviouslySeenCards(first: Card, second: Card){
        // Add if it is not already present.
        if(!previouslySeenCards.contains(first.identifier)){
            previouslySeenCards.append(first.identifier)
        }
        
        if(!previouslySeenCards.contains(second.identifier)){
            previouslySeenCards.append(second.identifier)
        }
    }
    
}
