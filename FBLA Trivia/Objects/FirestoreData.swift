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
        let id = UUID().uuidString
        FirestoreData.data.collection("game-sessions").document("\(id)").setData([
            "id": "\(id)",
            "Players": ["\(Auth.auth().currentUser!.displayName!)" ],
            "ActivePlayers": ["\(Auth.auth().currentUser!.displayName!)" ],
            "InActivePlayers": [],
            "Images": [],
            "GameActivity": false
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
            view.performSegue(withIdentifier: "segueToCategouriesVC", sender: view)
        }
    }
    
    func addPlayer(_ player: User, to session: String, onComplete: @escaping (Bool) -> Void) {
        //Add user to sessions Players array
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.updateData(["Players" : FieldValue.arrayUnion(["\(player.displayName!)"])]) { err in
            if let err = err {
                print("Error adding player: \(err)")
                onComplete(false)
            } else {
                print("PLayer successfully added!")
                session.updateData(["ActivePlayers" : FieldValue.arrayUnion(["\(player.displayName!)"])]) { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                        onComplete(false)
                    } else {
                        print("Player successfully added!")
                        onComplete(true)
                    }
                }
            }
        }
    }
    
    func removePlayer(_ player: String, from session: String, onComplete: @escaping (Bool) -> Void) {
        //Remove player from the session
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.getDocument { (snapshot, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                let sessionSnapshot = Session((snapshot?.data())!)
                
                if sessionSnapshot.players.contains(where: { (returnedPlayer) -> Bool in
                    if player == returnedPlayer {
                        return true
                    } else {
                        return false
                    }
                }) {
                    session.updateData(["Players" : FieldValue.arrayRemove(["\(player)"])]) { err in
                        if let err = err {
                            print("Error removing document: \(err)")
                            onComplete(false)
                        } else {
                            print("PLayer successfully removed from players!")
                            if sessionSnapshot.activePlayers.contains(where: { (ply) -> Bool in
                                if player == (ply) {
                                    return true
                                } else {
                                    return false
                                }
                            }) {
                                session.updateData(["ActivePlayers" : FieldValue.arrayRemove(["\(player)"])]) { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                        onComplete(false)
                                    } else {
                                        print("PLayer successfully removed from ActivePlayers!")
                                        onComplete(true)
                                    }
                                }
                            } else if sessionSnapshot.inActivePlayers.contains(where: { (ply) -> Bool in
                                if player == (ply ) {
                                    return true
                                } else {
                                    return false
                                }
                            }) {
                                session.updateData(["InActivePlayers" : FieldValue.arrayRemove(["\(player)"])]) { err in
                                    if let err = err {
                                        print("Error removing document: \(err)")
                                        onComplete(false)
                                    } else {
                                        print("Player successfully removed form InActivePlayers!")
                                        onComplete(true)
                                    }
                                }
                            }
                            
                        }
                    }
                }
                
                
                
            }
        }
    }
    
    func activatePlayer(_ player: User, in session: String, onComplete: @escaping (Bool) -> Void) {
        //Add user to sessions activeplayers array and remove from in-activePlayers array.
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.updateData(["InActivePlayers" : FieldValue.arrayUnion(["\(player.displayName!)"])]) { err in
            if let err = err {
                print("Error removing document: \(err)")
                onComplete(false)
            } else {
                print("Document successfully removed!")
                session.updateData(["ActivePlayers" : FieldValue.arrayRemove(["\(player.displayName!)"])]) { err in
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
    }
    
    func inActivatePlayer(_ player: User, in session: String, onComplete: @escaping (Bool) -> Void) {
        //Add user to sessions in-activePlayers array and remove from activePlayers array.
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.updateData(["ActivePlayers" : FieldValue.arrayUnion(["\(player.displayName!)"])]) { err in
            if let err = err {
                print("Error removing document: \(err)")
                onComplete(false)
            } else {
                print("Document successfully removed!")
                session.updateData(["InActivePlayers" : FieldValue.arrayRemove(["\(player.displayName!)"])]) { err in
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
