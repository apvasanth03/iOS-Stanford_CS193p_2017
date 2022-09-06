//
//  ViewController.swift
//  PlayingCard
//
//  Created by Vasanthakumar Annadurai on 06/09/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK : Variables
    @IBOutlet weak var playingCardView: PlayingCardView!{
        didSet{
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(nextCard))
            swipeGesture.direction = [.right, .left]
            playingCardView.addGestureRecognizer(swipeGesture)
            
            let pinchGesture = UIPinchGestureRecognizer(target: playingCardView, action: #selector(PlayingCardView.adjustFaceCardScale(byHandlingGestureRecogonizedBy:)))
            playingCardView.addGestureRecognizer(pinchGesture)
        }
    }
    
    var deck = PlayingCardDeck()
    
    // MARK : Overriden Methods.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK : Action Methods.
    // Gets called when we swipe through the playingCard.
    @objc func nextCard(){
        if let card = deck.draw(){
            playingCardView.rank = card.rank.order
            playingCardView.suit = card.suit.rawValue
        }
    }
    
    // Gets called when we tap playingCard
    @IBAction func flipCard(_ sender: UITapGestureRecognizer) {
        switch sender.state{
        case .ended:
            playingCardView.isFaceUp = !playingCardView.isFaceUp
        default: break
        }
    }

}

