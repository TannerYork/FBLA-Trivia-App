//
//  SessionPlayers.swift
//  KnockOut
//
//  Created by Tanner York on 11/26/18.
//  Copyright © 2018 Tanner York. All rights reserved.
//

import Foundation
import Firebase


//May not be needed 
class GameSession {
    static let shared = GameSession()
    
    var localPlayer: String?
    var localPlayerId: String?
    var modesNotComplete: [Int] = [1,2,3,4,5,6,7,8]
    var players: [String] = []
    var playerScores: [[String: Any]] = [] //Int index responds to when player joined.
    var PlayerSession: String?
    var AdminSession: String?
    var updateChecker: ListenerRegistration!
    var gameActivityChecker: ListenerRegistration!
    var shouldSegueToCategories = false
    
    
     func removeListeners() {
        gameActivityChecker.remove()
        updateChecker.remove()
    }

    
    func loadData(for tableView: UITableView, in view: UIViewController, onComplete: @escaping (Bool) -> Void) {
        print(PlayerSession ?? AdminSession!)
        FirestoreData.data.collection("game-sessions").document("\(PlayerSession ?? AdminSession!)").getDocument { (snap, error) in
            if let err = error {
                print(err.localizedDescription)
            } else {
                guard let document = snap, snap!.exists else {onComplete(false); return}
                print(document.documentID)
                guard let data = document.data() else {print("Error getting initial data"); onComplete(false); return}
                
                print(data)
                self.players.removeAll()
                self.players.append(contentsOf: data["Players"] as! Array)
                
                tableView.reloadData()
                onComplete(true)
                
            }
        }
    }
    
    func checkForUpdates(for tableView: UITableView) -> ListenerRegistration {
        let listener = FirestoreData.data.collection("game-sessions").document("\(PlayerSession ?? AdminSession!)").addSnapshotListener { documentSnapshot, error in
            
            guard let document = documentSnapshot else { print("Error getting snapshot \(error!)"); return}
            guard let data = document.data() else {print("Error getting data"); return}
            
            self.players.removeAll()
            self.players.append(contentsOf: data["Players"] as! Array)
            print("Players: \(self.players)")
            
            
            tableView.reloadData()
            
        }
        return listener
    }
    
    

    func checkIfGameIsActive() -> ListenerRegistration {
        let listener = FirestoreData.data.collection("game-sessions").document("\(PlayerSession ?? AdminSession!)").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {print("Error setting activity document"); return}
            guard let data = document.data() else {print("Error setting activity data"); return}
            
            //Updates PlayerScores
            self.playerScores.removeAll()
            for player in GameSession.shared.players {
                if let playerData = data[player] as? [String: Any] {
                    print("PlayerData set")
                    self.playerScores.append([playerData["DisplayName"] as! String: playerData["Score"] as Any])
                }
            }
            print("Scores: \(self.playerScores)")
            
            //Check if player is still in game
            self.players.removeAll()
            self.players.append(contentsOf: data["Players"] as! Array)
            print("Players: \(self.players)")
            
            var isPlayerInSession = false
            for player in self.players {
                if player == self.localPlayer {
                    isPlayerInSession = true
                }
            }
            
            //Do nothing if game exist and player is in it. Remove listener and unwind to optionsVC, if either are false.
            
            if data["GameActivity"] as! Bool == true && document.exists == true && isPlayerInSession == true {
                if self.shouldSegueToCategories == true {
                    let view = UIApplication.shared.topMostViewController()
                    view?.performSegue(withIdentifier: "segueToCategoriesVC", sender: view)
                }
            } else if document.exists == false || isPlayerInSession == false {
                //Unwind to option view cintroller
                self.gameActivityChecker.remove()
                self.updateChecker.remove()
                let view = UIApplication.shared.topMostViewController()
                view!.performSegue(withIdentifier: "unwindToOptionsVC", sender: view )
            }
            
        }
        return listener
    }
    
    
    func updateScore(for player: String, in session: String, to int: Int, onComplete: @escaping (Bool) -> Void) {
        let session = FirestoreData.data.collection("game-sessions").document("\(session)")
        session.updateData([player: ["DisplayName": player, "Score": int]])
        
    }
}
