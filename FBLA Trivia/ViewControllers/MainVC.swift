//
//  MainVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class MainVC: UIViewController, FUIAuthDelegate {

    //MARK: Properties
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
    //MARK: Actions
    
    @IBAction func signIn(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()
        authUI!.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            FUIFacebookAuth(),
            ]
        authUI!.providers = providers
        
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true)
        
        
        
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        // handle user and error as necessary
        print(error?.localizedDescription as Any)
        print(user as Any)
        if user != nil {
            signInButton.isHidden = true
            signOutButton.isHidden = false
            playButton.isHidden = false
            GameSession.shared.localPlayer = Player(from: user!).userName
        }
    }
    
    @IBAction func signOut(_ sender: Any) {
        try! Auth.auth().signOut()
    }
    
}
