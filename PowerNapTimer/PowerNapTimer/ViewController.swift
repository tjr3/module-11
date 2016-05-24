//
//  ViewController.swift
//  PowerNapTimer
//
//  Created by James Pacheco on 4/12/16.
//  Copyright © 2016 James Pacheco. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimerDelegate {
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    let timer = Timer()
    
    private let localNotificationTag = "timerNotification"
       
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        resetTimer()
        timer.delegate = self
    }
    
    // MARK: - View Based Method
    
    func setView() {
        updateTimerLabel()
        // If timer is running, start button title should say "Cancel". If timer is not running, title should say "Start nap"
        if timer.isOn {
            startButton.setTitle("Cancel", forState: .Normal)
        } else {
            startButton.setTitle("Start nap", forState: .Normal)
        }
    }
    
    func updateTimerLabel() {
        timerLabel.text = timer.timeAsString()
    }
    
    func resetTimer() {
        guard let localNotifications = UIApplication.sharedApplication().scheduledLocalNotifications else { return }
        let timerLocalNotifications = localNotifications.filter({$0.category == localNotificationTag})
        guard let timerNotification = timerLocalNotifications.last, fireDate = timerNotification.fireDate else { return }
        for notification in timerLocalNotifications {
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
            timer.stopTimer()
            timer.startTimer(fireDate.timeIntervalSinceNow)

        
    }
    // MARK: - Action Buttons
    
    @IBAction func startButtonTapped(sender: AnyObject) {
        if timer.isOn {
            timer.stopTimer()
            cancelLocalNotification()
        } else {
            timer.startTimer(12.0)
            scheduleLocalNotificaiton()
        }
        setView()
    }
    
    // MARK: - Timer Delegate Methods
    func timerSecondTick() {
        updateTimerLabel()
            
    }
    func timerStopped() {
        setView()
        cancelLocalNotification()
        
    }
    func timerCompleted() {
        setView()
        var snoozeTextField: UITextField?
        let alert = UIAlertController(title: "Timer Done!", message: "Wake Up", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Sleep in a few more minutes..."
            textField.keyboardType = .NumberPad
            snoozeTextField = textField
        }
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel) { (_) in
            self.setView()
        }
        let snoozeAction = UIAlertAction(title: "Snooze", style: .Default) { (_) in
            guard let timeText = snoozeTextField?.text, time = NSTimeInterval(timeText) else { return }
            self.timer.startTimer(time*60)
            self.scheduleLocalNotificaiton()
            self.setView()
            
        }

        alert.addAction(dismissAction)
        alert.addAction(snoozeAction)
        presentViewController(alert, animated: true, completion: nil)
        }
    
    // MARK: - Local Notification Methods
    
    func scheduleLocalNotificaiton() {
        guard let timerTime = timer.timeRemaining else { return }
        let localNotification = UILocalNotification()
        localNotification.category = localNotificationTag
        localNotification.alertBody = "It's time to get up!"
        localNotification.alertTitle = "Time's Up"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: timerTime)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
    func cancelLocalNotification() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
    }
        
    }
    


