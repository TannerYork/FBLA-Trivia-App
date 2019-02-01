//
//  QuestionsLists.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/31/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import Foundation

class FBLAHistory {
    static let shared = FBLAHistory()
    var questions: [Question] = []
}

class CompetitiveEvents {
    static let shared = CompetitiveEvents()
    var questions: [Question] = []
}

class Events {
    static let shared = Events()
    var questions: [Question] = []
}

class NationalOfficers {
   static let shared = NationalOfficers()
    var questions: [Question] = []
}

class ParliamenaryProcedure {
   static let shared = ParliamenaryProcedure()
    var questions: [Question] = []
}

class Excel {
   static let shared = Excel()
    var questions: [Question] = []
}


