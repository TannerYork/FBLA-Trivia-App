//
//  SixVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit

class SixVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Actions
    @IBAction func unwindToModeVC(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToModesVC", sender: self)
    }
}
