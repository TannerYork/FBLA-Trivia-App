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
    var modesNotComplete: [Int] = [1,2,3,4,5,6,7,8]
    var players: [String] = []
    var playerScores: [Int] = [] //Int index responds to when player joined.
    
    var PlayerSession: String?
    var AdminSession: String?
    

    
    
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
            
            self.activePlayers.removeAll()
            self.activePlayers.append(contentsOf: data["ActivePlayers"] as! Array)
            print("ActivePlayers: \(self.activePlayers)")
            
            tableView.reloadData()
            
        }
        return listener
    }
    
    func checkIfGameIsActiveAdmin(from view: UIViewController) -> ListenerRegistration {
        let listener = FirestoreData.data.collection("game-sessions").document("\(AdminSession!)").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {print("Error setting activity document"); return}
            guard let data = document.data() else {print("Error setting activity data"); return}

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let adminLobbyView = storyboard.instantiateViewController(withIdentifier: "AdminVC") as! AdminVC
           
            
                if data["GameActivity"] as! Bool == true && document.exists == true {
                } else if document.exists == false {
                    //Unwind to option view cintroller
                    adminLobbyView.updateChecker.remove()
                    adminLobbyView.gameActivityChecker.remove()
                    view.performSegue(withIdentifier: "unwindToOptionsVC", sender: view)
                }
            
        }
        return listener
    }
    
    func checkIfGameIsActivePlayer(from view: UIViewController) -> ListenerRegistration {
        let listener = FirestoreData.data.collection("game-sessions").document("\(PlayerSession!)").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {print("Error setting activity document"); return}
            guard let data = document.data() else {print("Error setting activity data"); return}
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let playerLobbyView = storyboard.instantiateViewController(withIdentifier: "GamePlayerVC") as! PlayerVC
            
                if data["GameActivity"] as! Bool == true && document.exists == true {
                    view.performSegue(withIdentifier: "segueToCategoriesVC", sender: view)
                } else if document.exists == false {
                    //Unwind to option view controller
                    playerLobbyView.updateChecker.remove()
                    playerLobbyView.gameActivityChecker.remove()
                    view.performSegue(withIdentifier: "unwindToOptionsVC", sender: view)
                }
        }
        return listener
    }
    
    func checkIfGameIsActive(from view: UIViewController) -> ListenerRegistration {
        let listener = FirestoreData.data.collection("game-sessions").document("\(PlayerSession ?? AdminSession!)").addSnapshotListener { (documentSnapshot, error) in
            guard let document = documentSnapshot else {print("Error setting activity document"); return}
            guard let data = document.data() else {print("Error setting activity data"); return}
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let categoriesVC = storyboard.instantiateViewController(withIdentifier: "CategoriesVC") as! CategoriesVC
            
            
            if data["GameActivity"] as! Bool == true && document.exists == true {
            } else if document.exists == false {
                //Unwind to option view cintroller
                categoriesVC.gameChecker.remove()
                view.performSegue(withIdentifier: "unwindToOptionsVC", sender: view)
            }
            
        }
        return listener
    }
}
