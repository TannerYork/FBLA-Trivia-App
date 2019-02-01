//
//  FirebaseDatabase.swift
//  KnockOut
//
//  Created by Tanner York on 12/6/18.
//  Copyright © 2018 Tanner York. All rights reserved.
//

import Foundation
import Firebase


class FirestoreData {
    static let shared = FirestoreData()
    static let data = Firestore.firestore()
    let fileData = Data()
    
    func createSession(onComplete: @escaping (Bool, String) -> Void) {
        let id = randomString(length: 5).uppercased()
        FirestoreData.data.collection("game-sessions").document("\(id)").setData([
            "id": "\(id)",
            "GameActivity": false,
            "Players": [GameSession.shared.localPlayer],
            "\(GameSession.shared.localPlayer!)": ["DisplayName": GameSession.shared.localPlayer!, "Score": 0, "isComplete": false]
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
                onComplete(false, "Error")
            } else {
                print("Document successfully written!")
                onComplete(true, "\(id)")
                print(id)
                
            }
        }
    }
    
    func startSession(from view: UIViewController) {
        FirestoreData.data.collection("game-sessions").document("\(GameSession.shared.PlayerSession ?? GameSession.shared.AdminSession!)").updateData(["GameActivity": true]) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                FirestoreData.shared.deleteSession(GameSession.shared.PlayerSession ?? GameSession.shared.AdminSession!, onComplete: { (bool) in
                    if bool == true {
                        print("Session: \(GameSession.shared.PlayerSession ?? GameSession.shared.AdminSession!) deleted.")
                        view.performSegue(withIdentifier: "unwindToOptionsVC", sender: view)
                    } else {
                        print("Session: \(GameSession.shared.PlayerSession ?? GameSession.shared.AdminSession!) was not deleted")
                        view.performSegue(withIdentifier: "unwindToOptionsVC", sender: view)
                    }
                })
                return
            }
            view.performSegue(withIdentifier: "segueToCategoriesVC", sender: view)
        }
    }
    
    func addPlayer(_ player: User, to session: String, onComplete: @escaping (Bool) -> Void) {
        //Add user to sessions Players array
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.setData([player.displayName!: ["DisplayName": GameSession.shared.localPlayer!, "Score": 0, "isComplete": false]], merge: true)
        
        session.updateData(["Players" : FieldValue.arrayUnion(["\(player.displayName!)"])]) { err in
            if let err = err {
                print("Error adding player: \(err)")
                onComplete(false)
            } else {
                print("Player successfully added!")
                onComplete(true)
            }
        }
        
    }
    
    func removePlayer(_ player: String, from session: String, onComplete: @escaping (Bool) -> Void) {
        //Remove player from the session
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.updateData([player: FieldValue.delete()])
        
        session.getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                if GameSession.shared.players.contains(player) {
                    
                    session.updateData(["Players" : FieldValue.arrayRemove(["\(player)"])]) { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                            onComplete(false)
                        } else {
                            print("PLayer successfully removed from players!")
                            onComplete(true)
                        }
                    }
                }
                
            }
        }
        
    }
    
    func deleteSession(_ session: String, onComplete: @escaping (Bool) -> Void) {
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
                onComplete(false)
            } else {
                print("Document successfully removed!")
                onComplete(true)
            }
        }
    }
}


extension FirestoreData {
    
    func getcompetitiveEventsQuestions(onComplete: @escaping (Bool) -> Void) {
        let document = FirestoreData.data.collection("Competitive Events").document("Questions")
        
        document.getDocument { (snap, error) in
            if let error = error {
                print("Error getting competitive events questions")
                print(error.localizedDescription)
                onComplete(false)
            } else {
                guard let document = snap, snap!.exists else {print("Error setting document as snap"); onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                let questions = data["Questions"] as! [[String: String]]
                
                for question in questions {
                    let setQuestion = Question(data: question)
                    CompetitiveEvents.shared.questions.append(setQuestion)
                }
                onComplete(true)
            }
        }
    }
    
    func getEventsQuestions(onComplete: @escaping (Bool) -> Void) {
        let document = FirestoreData.data.collection("Events").document("Questions")
        
        document.getDocument { (snap, error) in
            if let error = error {
                print("Error getting competitive events questions")
                print(error.localizedDescription)
                onComplete(false)
            } else {
                guard let document = snap, snap!.exists else {print("Error setting document as snap"); onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                let questions = data["Questions"] as! [[String: String]]
                
                for question in questions {
                    let setQuestion = Question(data: question)
                    Events.shared.questions.append(setQuestion)
                }
                onComplete(true)
            }
        }
    }
    
    func getFBLAHistoryQuestions(onComplete: @escaping (Bool) -> Void) {
        let document = FirestoreData.data.collection("FBLA History").document("Questions")
        
        document.getDocument { (snap, error) in
            if let error = error {
                print("Error getting competitive events questions")
                print(error.localizedDescription)
                onComplete(false)
            } else {
                guard let document = snap, snap!.exists else {print("Error setting document as snap"); onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                let questions = data["Questions"] as! [[String: String]]
                
                for question in questions {
                    let setQuestion = Question(data: question)
                    FBLAHistory.shared.questions.append(setQuestion)
                }
                onComplete(true)
            }
        }
    }
    
    func getNationalOfficerQuestions(onComplete: @escaping (Bool) -> Void) {
        let document = FirestoreData.data.collection("National Officers").document("Questions")
        
        document.getDocument { (snap, error) in
            if let error = error {
                print("Error getting competitive events questions")
                print(error.localizedDescription)
                onComplete(false)
            } else {
                guard let document = snap, snap!.exists else {print("Error setting document as snap"); onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                let questions = data["Questions"] as! [[String: String]]
                
                for question in questions {
                    let setQuestion = Question(data: question)
                    NationalOfficers.shared.questions.append(setQuestion)
                }
                onComplete(true)
            }
        }
    }
    
    
    func getParliamentaryQuestions(onComplete: @escaping (Bool) -> Void) {
        let document = FirestoreData.data.collection("Parliamentary Procedure").document("Questions")
        
        document.getDocument { (snap, error) in
            if let error = error {
                print("Error getting competitive events questions")
                print(error.localizedDescription)
                onComplete(false)
            } else {
                guard let document = snap, snap!.exists else {print("Error setting document as snap"); onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                let questions = data["Questions"] as! [[String: String]]
                
                for question in questions {
                    let setQuestion = Question(data: question)
                    ParliamenaryProcedure.shared.questions.append(setQuestion)
                }
                onComplete(true)
            }
        }
    }
    
    func getExcelQuestions(onComplete: @escaping (Bool) -> Void) {
        let document = FirestoreData.data.collection("Excel").document("Questions")
        
        document.getDocument { (snap, error) in
            if let error = error {
                print("Error getting competitive events questions")
                print(error.localizedDescription)
                onComplete(false)
            } else {
                guard let document = snap, snap!.exists else {print("Error setting document as snap"); onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                let questions = data["Questions"] as! [[String: String]]
                
                for question in questions {
                    let setQuestion = Question(data: question)
                    Excel.shared.questions.append(setQuestion)
                }
                onComplete(true)
            }
        }
    }
    
    func randomString(length: Int) -> String {//This will be used to create people names and favorite things
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        //This will take the length and spit out random letters
        return String((0...length-1).map{ _ in letters.randomElement()! })
    }
    
}
