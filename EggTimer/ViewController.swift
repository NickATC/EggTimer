//
//  ViewController.swift
//  EggTimer
//
//  Created by Angela Yu on 08/07/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    
    var player: AVAudioPlayer!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var secondsRemainingLabel: UILabel!
    @IBOutlet weak var secondsRemainFixedLbl: UILabel!
    @IBOutlet weak var stopBtn: UIButton!
    
        let eggTimes: [String : Int] = [
        "Soft" : 300,
        "Medium" :420,
        "Hard" : 720
    ]
    
    //Shorter times for testing purposes!
    //2 B removed!
//    let eggTimes: [String : Float] = [
//          "Soft" : 3,
//          "Medium" :4,
//          "Hard" : 7
//      ]
    
    var secondsRemaining: Float = 60
    var timer = Timer()
    var progress: Float = 1.0
    var fullTime: Float = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStartView()
    }
    
    func setStartView() {
        timer.invalidate()
        
        titleLabel.text = "How do you like your eggs?"
        setTitleRegularFormat()
        hideElements()
    }
    
    func hideElements() {
        secondsRemainingLabel.alpha = 0
        secondsRemainFixedLbl.alpha = 0
        progressBar.alpha = 0
        stopBtn.alpha = 0
    }
    
    func showElements() {
        secondsRemainingLabel.alpha = 1
        secondsRemainFixedLbl.alpha = 1
        secondsRemainingLabel.text = ""
        progressBar.alpha = 1
        stopBtn.alpha = 1
    }
    
    func setTitleRegularFormat(){
        titleLabel.font = titleLabel.font.withSize(30)
        titleLabel.textColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00)
    }
    
    func showDoneText() {
        hideElements()
        titleLabel.text = "DONE!!"
        titleLabel.font = titleLabel.font.withSize(60)
        titleLabel.textColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00)
        setAlarm()
    }

    func setAlarm(){
        guard let url = Bundle.main.url(forResource: "alarm_sound", withExtension: "mp3") else { return }

                    do {
                        try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                        try AVAudioSession.sharedInstance().setActive(true)

                        player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

                        guard let player = player else { return }

                        player.play()

                    } catch let error {
                        print(error.localizedDescription)
                    }
    }
    
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    @objc func updateCounter() {
        //sets and updates progress bar as seconds go by
        progress = secondsRemaining / fullTime
        progressBar.progress = progress
        
        if secondsRemaining > 0 {
            let (_,m,s) = secondsToHoursMinutesSeconds(seconds: Int(secondsRemaining))
            
            secondsRemainingLabel.text = "\(m) Min : \(s) Sec"
            //secondsRemainingLabel.text = "\(Int(secondsRemaining))"
            print("\(Int(secondsRemaining)) seconds.")
            secondsRemaining -= 1
        } else {
            timer.invalidate()
            hideElements()
            showDoneText()
        }
    }
    
    
    
    //Buttons actions:
    //Egg buttons pressed.
    @IBAction func hardnessSelected(_ sender: UIButton) {
        
        showElements()
        setTitleRegularFormat()
        
        let hardness: String = sender.currentTitle!
        
        titleLabel.text = "Cooking \(hardness.lowercased()) eggs!"
        secondsRemaining = Float(eggTimes[hardness]!)
        fullTime = Float(eggTimes[hardness]!)
        
        timer.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    //Stop button pressed.
    @IBAction func stopBtnPressed(_ sender: Any) {
        setStartView()
    }



}
