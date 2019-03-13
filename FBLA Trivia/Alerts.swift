//
//  Alerts.swift
//  KnockOut
//
//  Created by Tanner York on 11/26/18.
//  Copyright © 2018 Tanner York. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class Alerts {
    static let shared = Alerts()
    
    //MARK: Constants
     let createGameAlert = UIAlertController(title: "Create Game", message: "Once you hit enter a special session id will be shown, give this to your friends so they can join the game.", preferredStyle: .alert)
    
     let joinGameAlert = UIAlertController(title: "Join Game", message: "Enter the id of the game session.", preferredStyle: .alert)
    
     let loginErrorAlert = UIAlertController(title: "Error Loging In", message: "Something went wrong with the login in proccess please check all fields are correct.", preferredStyle: .alert)
    
     let exitAppError = UIAlertController(title: "Fatal Error", message: "You must be signed in for the app to work. Closing app to prevent futher errors.", preferredStyle: .alert)
    
     let KnockOutErrorAlert = UIAlertController(title: "Processing Error", message: "Sorry, an error accured while try to send you photo.", preferredStyle: .alert)

    //MARK: Methods
    
    static func presentJoinGameAlert(from view: UIViewController) {
        view.present(Alerts.shared.joinGameAlert, animated: true, completion: nil)
    }
    static func presentCreateGameAlert(from view: UIViewController) {
        view.present(Alerts.shared.createGameAlert, animated: true, completion: nil)
    }
    static func presentLoginErrorAlert(from view: UIViewController) {
        view.present(Alerts.shared.loginErrorAlert, animated: true, completion: nil)
    }
    static func presentKnockOutErrorAlert(from view: UIViewController) {
        view.present(Alerts.shared.KnockOutErrorAlert, animated: true, completion: nil)
    }

    
    //Join session alert setup
     func setupJoinGameAlert(in view: UIViewController) {
        joinGameAlert.addTextField { (textField: UITextField) in
            textField.keyboardAppearance = .dark
            textField.keyboardType = .default
            textField.autocorrectionType = .default
            textField.placeholder = "game id"
            textField.clearButtonMode = .whileEditing
        }
        let join = UIAlertAction(title: "Join", style: .default) { action in
            let textfield = self.joinGameAlert.textFields![0]
            print(textfield.text as Any)
            guard let session = textfield.text, !textfield.text!.isEmpty else {
                return
            }
            FirestoreData.shared.addPlayer(Auth.auth().currentUser!, to: "\(session)", onComplete: { (completion) in
                if completion == true {
                    GameSession.shared.PlayerSession = session
                    print("\(GameSession.shared.players)")
                    view.performSegue(withIdentifier: "segueToPlayerVC", sender: view)
                } else {
                    self.joinGameAlert.message = "Sorry something went wrong. Make sure the session id you entered is correct."
                }
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            return
        }
        joinGameAlert.addAction(join)
        joinGameAlert.addAction(cancel)
    }
    
    //Create a new session alert setup
     func setupCreateGameAlert(in view: UIViewController) {
        let create = UIAlertAction(title: "Create", style: .default) { action in
            FirestoreData.shared.createSession(onComplete: { (completion, id) in
                if completion == true {
                    GameSession.shared.AdminSession = id
                    view.performSegue(withIdentifier: "segueToAdminVC", sender: view)
                } else {
                    self.createGameAlert.message = "Sorry an error accured while setting up session. This means the code is broken and that you will have to contact the OG developer about it so he can fix it."
                }
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { action in
            return
        }
        createGameAlert.addAction(create)
        createGameAlert.addAction(cancel)
    }
    
    //Loging in error alert setup
     func setupLoginErrorAlert(in view: UIViewController) {
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            return
        }
        loginErrorAlert.addAction(ok)
    }
    
    func setupKnockOutError(in view: UIViewController) {
        let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
            return
        }
        KnockOutErrorAlert.addAction(ok)
    }
    
    
    
}


