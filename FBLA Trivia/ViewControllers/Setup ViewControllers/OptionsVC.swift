//
//  OptionsVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit

class OptionsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Alerts.shared.setupCreateGameAlert(in: self)
        Alerts.shared.setupJoinGameAlert(in: self)
    }
    
    //MARK: Actions
    
    @IBAction func createGame(_ sender: Any) {
        //Creates an alert for game creation and presents the alert
        Alerts.presentCreateGameAlert(from: self)
    }
    
    @IBAction func joinGame(_ sender: Any) {
        //Creates an alert for joining a game and then presenting the alert
        Alerts.presentJoinGameAlert(from: self)
    }
    
    @IBAction func unwindToOptionsVC(segue: UIStoryboardSegue) {
    }
    
    
}
