//
//  Question.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/31/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import Foundation


class Question {
    
    let question: String
    let A1: String
    let A2: String
    let A3: String
    let A4: String
    let correctAnswer: String
    
    init(question: String, A1: String, A2: String, A3: String, A4: String, correctAnswer: String) {
        self.question = question
        self.A1 = A1
        self.A2 = A2
        self.A3 = A3
        self.A4 = A4
        self.correctAnswer = correctAnswer
    }
    
    required convenience init(data: [String:String]) {
        let question = data["Question"]
        let aOne = data["A1"]
        let aTwo = data["A2"]
        let aThree = data["A3"]
        let aFour = data["A4"]
        let correctAnswer = data["CorrectAnswer"]
        
        self.init(question: question!, A1: aOne!, A2: aTwo!, A3: aThree!, A4: aFour!, correctAnswer: correctAnswer!)
    }
    
    
    
}
