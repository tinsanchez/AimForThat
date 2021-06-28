//
//  ViewController.swift
//  AimForThat
//
//  Created by Valentin Sanchez on 23/04/2020.
//  Copyright © 2020 Valentin Sanchez. All rights reserved.
//

import UIKit
import QuartzCore

class GameViewController: UIViewController {
    
    var currentValue: Int = 0
    var targetValue: Int = 0
    var score: Int = 0
    var round: Int = 0
    var time : Int = 0
    var timer : Timer?
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        resetGame()
        setupSlider()
        
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
       /* var difference: Int = 0
        
        if self.currentValue > self.targetValue{
            difference = self.currentValue - self.targetValue
        }else{
            difference = self.targetValue - self.currentValue
        }*/
        
        let difference : Int = abs(self.currentValue - self.targetValue)
        
        var points = (difference > 0) ? 100 - difference : 1000
        
        self.score += points
        self.scoreLabel.text = "\(score)"
        
        var tittle : String = ""
        switch difference {
        case 0:
            tittle = "Puntuacion perfecta!"
            points = Int(10.0 * Float(points))
        case 1...5:
            tittle = "Casi perfecto."
            points = Int(1.5 * Float(points))
        case 6...12:
            tittle = "Te ha faltado poco."
            points = Int(1.2 * Float(points))
        default:
            tittle = "Has ido demasiado lejos..."
        }
        
        let message = "Has marcado \(points) puntos."
        
        let alert = UIAlertController(title: tittle , message: message , preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: { action in
            self.startNewRound()
            self.updateLabels()
        })
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func sliderMoved(_ sender: UISlider) {
        self.currentValue = lroundf(sender.value)
        
    }
    
    
    @IBAction func exitPressed(_ sender: UIButton) {
        resetGame()
        updateLabels()
        
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 1
        transition.timingFunction = CAMediaTimingFunction(name: .easeIn)
        self.view.layer.add(transition, forKey: nil)
    }
    
    func resetGame(){
        var maxScore = UserDefaults.standard.integer(forKey: "maxScore")
        if maxScore < self.score{
            maxScore = self.score
            UserDefaults.standard.set(maxScore, forKey: "maxScore")
        }
        self.recordLabel.text = "\(maxScore)"
        
        self.score = 0
        self.round = 0
        self.time = 60
        
        if timer != nil{
            timer?.invalidate()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
        self.startNewRound()
        self.updateLabels()
    }
    
    @objc func tick(){
        self.time -= 1
        self.timerLabel.text = "\(self.time)"
        if self.time <= 0{
            self.timerLabel.text = "0"
            self.timer?.invalidate()
            let title = "Levanta el arma!"
            let message = "Tu puntuacion ha sido \(self.score)"
            let alert = UIAlertController(title: title , message: message , preferredStyle: .alert)
            let action = UIAlertAction(title: "Dispara de nuevo", style: .default, handler: { action in
                self.resetGame()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
         }
    }
    
    func startNewRound(){
        self.targetValue = 1 + Int(arc4random_uniform(100))
        self.currentValue = 50
        self.slider.value = Float(self.currentValue)
        self.round += 1
    }
    
    func updateLabels(){
        self.targetLabel.text = "\(self.targetValue)"
        self.scoreLabel.text = "\(self.score)"
        self.roundLabel.text = "\(self.round)"
        self.timerLabel.text = "\(self.time)"
    }
    
    func setupSlider(){
        let ballSlider = UIImage(named: "Slider")
        let ballSliderLight = UIImage(named: "Slider Light")
        self.slider.setThumbImage(ballSlider, for: .normal)
        self.slider.setThumbImage(ballSliderLight, for: .highlighted)
    }
}

