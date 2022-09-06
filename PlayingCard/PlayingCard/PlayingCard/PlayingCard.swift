//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Vasanthakumar Annadurai on 06/09/22.
//

import Foundation

struct PlayingCard: CustomStringConvertible{
    
    var suit: Suit
    var rank: Rank
    var description: String{
        return "\(rank)\(suit)"
    }
    
    enum Suit: String, CustomStringConvertible{
        case spades = "♠️"
        case hearts = "❤️"
        case clubs = "♣️"
        case diamonds = "♦️"
        
        static let all = [Suit.spades, .hearts, .clubs, .diamonds]
        var description: String{
            return self.rawValue
        }
    }
    
    enum Rank: CustomStringConvertible {
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int{
            switch self{
            case .ace: return 1
            case .numeric(let rank): return rank
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        static var all: [Rank]{
            var allRank = [Rank.ace]
            for pips in 2...10{
                allRank.append(Rank.numeric(pips))
            }
            allRank += [Rank.face("J"), .face("Q"), .face("K")]
            return allRank
        }
        var description: String{
            switch self{
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return kind
            }
        }
    }
    
}
