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
        //        let id = UUID().uuidString
        let id = 10
        FirestoreData.data.collection("game-sessions").document("\(id)").setData([
            "id": "\(id)",
            "GameActivity": false,
            "Players": [GameSession.shared.localPlayer],
            "\(GameSession.shared.localPlayer!)": ["DisplayName": GameSession.shared.localPlayer, "Score": 0]
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
        session.setData([player.displayName!: ["DisplayName": GameSession.shared.localPlayer!, "Score": 0]], merge: true)
        
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
