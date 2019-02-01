//
//  SixVC.swift
//  FBLA Trivia
//
//  Created by Tanner York on 1/15/19.
//  Copyright © 2019 Tanner York. All rights reserved.
//

import UIKit

class SixVC: UIViewController {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        A1.shoudlAdjustFontSizeAutomatically(true)
        A2.shoudlAdjustFontSizeAutomatically(true)
        A3.shoudlAdjustFontSizeAutomatically(true)
        A4.shoudlAdjustFontSizeAutomatically(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = UIColor(red:0.94, green:0.74, blue:0.12, alpha:1.0)
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        FirestoreData.shared.getExcelQuestions { (bool) in
            if bool == false {
                print("Error getting questions")
                UIApplication.shared.endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                self.performSegue(withIdentifier: "unwindToModesVC", sender: self)
            } else {
                self.getQuestion()
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    //MARK: Properties
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var A1: UIButton!
    @IBOutlet weak var A2: UIButton!
    @IBOutlet weak var A3: UIButton!
    @IBOutlet weak var A4: UIButton!
    
    var questionsAnswered: [Question] = []
    var currentScore = 0
    
    var currentQuestion: Question! {
        didSet {
            if let currentQuestion = currentQuestion {
                print(currentQuestion.question)
                print(currentQuestion.correctAnswer)
                textView.text = currentQuestion.question // Show the new text visually after the code is changed
                A1.setTitle(currentQuestion.A1, for: .normal)
                A2.setTitle(currentQuestion.A2, for: .normal)
                A3.setTitle(currentQuestion.A3, for: .normal)
                A4.setTitle(currentQuestion.A4, for: .normal)
                setColors()
            }
        }
    }
    
    //MARK: Actions
    @IBAction func AnswerTapped(_ sender: UIButton) {
        print(sender.tag)
        if sender.titleLabel!.text == currentQuestion?.correctAnswer {
            sender.backgroundColor = .green
            currentScore += 1
            UIApplication.shared.beginIgnoringInteractionEvents()
            sleep(3)
            self.activityIndicator.startAnimating()
            getQuestion()
        } else {
            sender.backgroundColor = .red
            UIApplication.shared.beginIgnoringInteractionEvents()
            sleep(3)
            self.activityIndicator.startAnimating()
            getQuestion()
        }
    }
    
    func getQuestion() {
        if Excel.shared.questions.count > 0 {
            let index = Int.random(in: 0..<Excel.shared.questions.count)
            setColors()
            currentQuestion = Excel.shared.questions[index]
            Excel.shared.questions.remove(at: index)
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        } else {
            //Add currentScore to users' total scores and update firestore data.
            let index = GameSession.shared.getPlayerScoreIndex(of: GameSession.shared.localPlayer!)
            let playerScore = GameSession.shared.playerScores[index]
            print("\(playerScore.name!)'s score is about to increase")
            
            let newScore = playerScore.score + currentScore
            
            GameSession.shared.updateScore(for: GameSession.shared.localPlayer!, in: GameSession.shared.PlayerSession ?? GameSession.shared.AdminSession!, to: newScore) { (bool) in
                if bool == true {
                    self.questionsAnswered = []
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.performSegue(withIdentifier: "unwindToModesVC", sender: self)
                } else {
                    print("Error updating player score")
                }
            }
            
        }
    }
    
    func setColors() {
        let backgroundColors = [UIColor(red:0.18, green:0.34, blue:0.38, alpha:1.0),
                                UIColor(red:0.94, green:0.74, blue:0.12, alpha:1.0),
                                UIColor(red:0.85, green:0.56, blue:0.22, alpha:1.0),
                                UIColor(red:0.24, green:0.56, blue:0.65, alpha:1.0)]
        A1.backgroundColor = backgroundColors.randomElement()
        A2.backgroundColor = backgroundColors.randomElement()
        A3.backgroundColor = backgroundColors.randomElement()
        A4.backgroundColor = backgroundColors.randomElement()
    }
    
    
}
