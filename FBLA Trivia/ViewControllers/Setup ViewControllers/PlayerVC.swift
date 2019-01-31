//
//  PlayerVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase

class PlayerVC: UIViewController {

    //MARK: Properties
    @IBOutlet weak var playersTV: UITableView!
    var updateChecker: ListenerRegistration!
    var gameActivityChecker: ListenerRegistration!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GameSession.shared.loadData(for: playersTV, in: self) { (bool) in
            self.updateChecker = GameSession.shared.checkForUpdates(for: self.playersTV)
            self.gameActivityChecker = GameSession.shared.checkIfGameIsActivePlayer(from: self)
        }
    }
    
    
    //MARK: Actions
    @IBAction func leaveGame(_ sender: Any) {
        //Remove player from session and return them to the game options.
        FirestoreData.shared.removePlayer(Auth.auth().currentUser!.displayName!, from: GameSession.shared.PlayerSession!) { (completion) in
            if completion == true {
                self.dismiss(animated: true)
            } else {
                print("ERROR!! Player was not remove from session!")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToCategoriesVC" {
            let destination = segue.destination as! CategoriesVC
            
            destination.gameChecker = GameSession.shared.checkIfGameIsActive(from: destination)
            self.updateChecker.remove()
            self.gameActivityChecker.remove()
        } else if segue.identifier == "unwindToOptionsVC" {
            GameSession.shared.modesNotComplete = [1,2,3,4,5,6,7,8]
            
            self.updateChecker.remove()
            self.gameActivityChecker.remove()
        }
    }
}

extension PlayerVC: UITableViewDelegate, UITableViewDataSource {
    
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
}
