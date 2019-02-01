//
//  CategouryVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit
import Firebase
import TTFortuneWheel

class CategoriesVC: UIViewController {
    
    //MARK: Properties
    var gameChecker: ListenerRegistration!
    var segueNumber: Int?
    
    @IBOutlet weak var spinningWheel: TTFortuneWheel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let slices = [ CarnivalWheelSlice.init(title: "Competitive Events"),
                       CarnivalWheelSlice.init(title: "Events"),
                       CarnivalWheelSlice.init(title: "National Officers"),
                       CarnivalWheelSlice.init(title: "Parliamentary Procedure"),
                       CarnivalWheelSlice.init(title: "Excel"),
                       CarnivalWheelSlice.init(title: "FBLA History")]
       
        
        spinningWheel.slices = slices
        spinningWheel.equalSlices = true
        spinningWheel.frameStroke.width = 0
        spinningWheel.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CarnivalWheelSlice
            let offset = pair.offset
            switch offset % 3 {
            case 0: slice.style = .brickRed
            case 1: slice.style = .sandYellow
            case 2: slice.style = .babyBlue
            case 3: slice.style = .deepBlue
            default: slice.style = .brickRed
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToOptionsVC" {
            GameSession.shared.modesNotComplete = [1,2,3,4,5,6]
        }
    }
    
    @IBAction func unwindToModesVC(segue: UIStoryboardSegue) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func rotateButton(_ sender: Any) {
        
        if GameSession.shared.modesNotComplete.count == 0 {
            //Segue to waiting room and remove other listeners
            
            
            
            let view = UIApplication.shared.topMostViewController()
            view?.performSegue(withIdentifier: "segueToGameOverVC", sender: view)
            
        } else {
            let int = GameSession.shared.modesNotComplete.randomElement()
            let index = GameSession.shared.modesNotComplete.firstIndex(of: int!)
            print(int as Any)
            GameSession.shared.modesNotComplete.remove(at: index!)
            spinningWheel.startAnimating()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.spinningWheel.startAnimating(fininshIndex: int!) { (finished) in
                    print("Segueing to \(int!)")
                    self.segueToMode(int!, from: self)
                }
            }
        }
    }
    
    func segueToMode(_ mode: Int, from view: UIViewController) {
        view.performSegue(withIdentifier: "segueTo\(mode)", sender: view)
        print(GameSession.shared.modesNotComplete)
    }

}


