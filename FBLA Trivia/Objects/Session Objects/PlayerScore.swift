//
//  PlayerScore.swift
//  FBLA Trivia
//
//  Created by Tanner York on 2/1/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import Foundation

class PlayerScore {
   var name: String!
   var score: Int!
   var isComplete: Bool!
    
    init(name: String, score: Int, isComplete: Bool) {
        self.name = name
        self.score = score
        self.isComplete = isComplete
    }
}
