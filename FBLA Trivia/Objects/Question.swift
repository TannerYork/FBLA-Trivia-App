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
    let aOne: String
    let aTwo: String
    let aThree: String
    let aFour: String
    let correctAnswer: String
    
    init(question: String, aOne: String, aTwo: String, aThree: String, aFour: String, correctAnswer: String) {
        self.question = question
        self.aOne = aOne
        self.aTwo = aTwo
        self.aThree = aThree
        self.aFour = aFour
        self.correctAnswer = correctAnswer
    }
    
    required convenience init(data: [String:String]) {
        let question = data["question"]
        let aOne = data["aOne"]
        let aTwo = data["aTwo"]
        let aThree = data["aThree"]
        let aFour = data["aFour"]
        let correctAnswer = data["correctAnswer"]
        
        self.init(question: question!, aOne: aOne!, aTwo: aTwo!, aThree: aThree!, aFour: aFour!, correctAnswer: correctAnswer!)
    }
    
    
    
}
