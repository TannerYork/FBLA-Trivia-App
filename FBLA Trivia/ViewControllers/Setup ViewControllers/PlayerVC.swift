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

    override func viewDidLoad() {
        super.viewDidLoad()
        GameSession.shared.loadData(for: playersTV, in: self) { (bool) in
            GameSession.shared.shouldSegueToCategories = true
            GameSession.shared.updateChecker = GameSession.shared.checkForUpdates(for: self.playersTV)
            GameSession.shared.gameActivityChecker = GameSession.shared.checkIfGameIsActive()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    
    //MARK: Actions
    @IBAction func leaveGame(_ sender: Any) {
        //Remove player from session and return them to the game options.
        GameSession.shared.gameActivityChecker.remove()
        GameSession.shared.updateChecker.remove()
        FirestoreData.shared.removePlayer(GameSession.shared.localPlayer!, from: GameSession.shared.PlayerSession!) { (completion) in
            if completion == true {
                self.dismiss(animated: true)
                GameSession.shared.resetData()
            } else {
                print("ERROR!! Player was not remove from session!")
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      GameSession.shared.shouldSegueToCategories = false
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
