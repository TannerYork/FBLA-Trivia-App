//
//  AdminVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase

class AdminVC: UIViewController {

    //MARK: Properties
    @IBOutlet weak var playersTV: UITableView!
    @IBOutlet weak var sessionIdLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameSession.shared.loadData(for: playersTV, in: self) { (bool) in
            GameSession.shared.shouldSegueToCategories = true
            GameSession.shared.updateChecker = GameSession.shared.checkForUpdates(for: self.playersTV)
            GameSession.shared.gameActivityChecker = GameSession.shared.checkIfGameIsActive()
            self.sessionIdLabel.text = GameSession.shared.AdminSession
        }
    }
    
    //MARK: Actions
    @IBAction func startGame(_ sender: Any) {
        //Set session activity to true and perform segue to CategoriesVC
        FirestoreData.shared.startSession(from: self)
    }
    
    @IBAction func cancelGame(_ sender: Any) {
        //Remove session from firebase. Then, return admin and users to GameOptionsVC
        FirestoreData.shared.deleteSession(GameSession.shared.AdminSession!) { (completion) in
            if completion == true {
                self.dismiss(animated: true)
            } else {
                print("ERROR!! Previous session was not deleted!")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        GameSession.shared.shouldSegueToCategories = false
    }
    
}

extension AdminVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of players: \(GameSession.shared.players.count)")
        return GameSession.shared.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell") as! PlayerCell
        let player = GameSession.shared.players[indexPath.row]
        cell.userNameLabel.text = player
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let removePlayer = UITableViewRowAction(style: .destructive, title: "Remove") { action, indexPath in
            let player = GameSession.shared.players[indexPath.row]
            if player == GameSession.shared.localPlayer {
                FirestoreData.shared.deleteSession(GameSession.shared.AdminSession!, onComplete: { (bool) in
                    if bool == true {
                    } else {
                        print("Error deleting session")
                    }
                })
            } else {
                FirestoreData.shared.removePlayer(player, from: GameSession.shared.AdminSession!, onComplete: { (completion) in
                    if completion == true{
                        print("\(player) was removed")
                        tableView.reloadData()
                    } else {
                        print("Error!! Player was not removed!")
                    }
                })
            }
        }
        return[removePlayer]
    }
}
