//
//  GameOverVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 2/1/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase

class GameOverVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        gameChecker = GameSession.shared.checkForUpdates(for: playersTableView)
        GameSession.shared.gameActivityChecker.remove()
    }

    //MARK: Properties
    @IBOutlet weak var playersTableView: UITableView!
    
    var playerRanking: [PlayerScore] = []
    var gameChecker: ListenerRegistration!
    
    //MARK: Actions
    @IBAction func didLeaveGame(_ sender: Any) {
        self.gameChecker.remove()
        print("Admin: \(String(describing: GameSession.shared.PlayerSession))")
        print("Player: \(String(describing: GameSession.shared.AdminSession))")
        if GameSession.shared.PlayerSession != nil {
            FirestoreData.shared.removePlayer(GameSession.shared.localPlayer!, from: GameSession.shared.PlayerSession!) { (bool) in
                if bool == false {
                    print("Error removing player from GAMEOVER VIEW")
                    self.gameChecker.remove()
                    GameSession.shared.resetData()
                    self.performSegue(withIdentifier: "unwindToOptionsVC", sender: self)
                } else {
                    self.gameChecker.remove()
                    GameSession.shared.resetData()
                    self.performSegue(withIdentifier: "unwindToOptionsVC", sender: self)
                }
            }
        } else if GameSession.shared.AdminSession != nil {
            FirestoreData.shared.deleteSession(GameSession.shared.AdminSession!) { (bool) in
                if bool == false {
                    print("Error removing player from GAMEOVER VIEW")
                    self.gameChecker.remove()
                    GameSession.shared.resetData()
                    self.performSegue(withIdentifier: "unwindToOptionsVC", sender: self)
                } else {
                    self.gameChecker.remove()
                    GameSession.shared.resetData()
                    self.performSegue(withIdentifier: "unwindToOptionsVC", sender: self)
                }
            }
        }
    }
}

extension GameOverVC: UITabBarDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameSession.shared.players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerScoreCell") as! PlayerScoreCell
        let player = GameSession.shared.playerScores[indexPath.row]
        cell.setupCell(for: player)
        return cell
    }
    
    
}
