//
//  CountDownViewController.swift
//  PostMessage
//
//  Created by System Administrator on 12/31/16.
//  Copyright © 2016 yangzhiqiong. All rights reserved.
//

import UIKit

class CountDownViewController: UIViewController {
    
    @IBOutlet weak var timeLeft: UILabel!

    var count_down_seconds : Int?
    
    var seconds : Int = 30
    var timer = Timer()
    
    
    
    @IBOutlet weak var StartButton: UIButton!
    
    
    @IBOutlet weak var StopButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let duration = count_down_seconds! * 60
        seconds = duration
        count_down_seconds = duration
        timeLeft.text = String(duration) + " Seconds"
        print("the duration is \(count_down_seconds)")
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func Start(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counter), userInfo: nil, repeats: true)
        StartButton.isUserInteractionEnabled = false
    
    }
    
    func counter()
    {
        if seconds > 0
        {
            seconds -= 1
            timeLeft.text = String(seconds) + " Seconds"
        }
        else if seconds <= 0
        {
            timer.invalidate()
            timeLeft.text = "0" + " Seconds"

        }
    }
    
    
    @IBAction func Stop(_ sender: Any) {
        timer.invalidate()
       // seconds =
        timeLeft.text = "0" + " Seconds"
        StopButton.isUserInteractionEnabled = true

    }
    

    @IBAction func Done(_ sender: Any) {
         presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
 

}

