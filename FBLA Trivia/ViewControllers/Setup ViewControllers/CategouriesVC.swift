//
//  CategouryVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase

class CategouriesVC: UIViewController {

    //MARK: Properties
    @IBOutlet weak var cOne: UILabel!
    @IBOutlet weak var cTwo: UILabel!
    @IBOutlet weak var cThree: UILabel!
    @IBOutlet weak var cFour: UILabel!
    @IBOutlet weak var cFive: UILabel!
    @IBOutlet weak var cSix: UILabel!
    
    
    var gameChecker: ListenerRegistration!
    let categouries = [1,2,3,4,5,6]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func chooseNumber() {
        var notChosen = true
        repeat {
            for 
        } while notChosen
    }

   

}
