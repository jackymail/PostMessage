//
//  ToDoItemViewController.swift
//  PostMessage
//
//  Created by System Administrator on 12/25/16.
//  Copyright © 2016 yangzhiqiong. All rights reserved.
//

import UIKit
import CloudKit





class ToDoItemViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate,UIPopoverPresentationControllerDelegate {
    
    var Database = CKContainer.default().publicCloudDatabase
    var taskPriority : Int = 0
    var taskStatus : Int = 0
    var recordID : CKRecordID?
    var savetype :Int?
    var task_duration : Int?
    
    @IBOutlet weak var duration: UITextField!
    
    func save_priority_to_cloud()
    {
        print("save priority to the cloud")
        Database.fetch(withRecordID: recordID!) { (record, error) in
            if(error != nil)
            {
                print("error is nil")
            }
            else
            {
                record?["priority"] = self.taskPriority as CKRecordValue?
                self.Database.save(record!, completionHandler: { (ckrcord, error) in
                    if error == nil
                    {
                        print("error is nil")
                    }})
                
            }
            
        }

    }
    
    
    
    

    
    
    
    #if false
    
    #if false
    @IBAction func save(_ sender: Any) {
        
        
        print("the save type is \(self.savetype)")
        
        if(self.savetype == 1)
        {
        
            Database.fetch(withRecordID: recordID!) { (record, error) in
            if(error != nil)
            {
                print("error is nil")
            }
            else
            {
              //  record?["content"] = self.taskname.text as CKRecordValue?
                self.Database.save(record!, completionHandler: { (ckrcord, error) in
                    if error == nil
                    {
                        print("error is nil")
                    }})
                
            }
            
            }
        }
        else if self.savetype == 2
        {
          print("save type is 2")
        }
    }    
    #endif
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {

        return true
        
    }
    #endif
   
    
    @IBAction func Done(_ sender: Any) {
    presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func Priority(_ sender: Any) {
      
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        
        let alert = SCLAlertView(appearance: appearance)
        
        alert.addButton("high") { 
            self.taskPriority = 1
            self.save_priority_to_cloud()
        }
        alert.addButton("middle") { 
            self.taskPriority = 2
            self.save_priority_to_cloud()
        }
        alert.addButton("low") { 
            self.taskPriority = 3
            self.save_priority_to_cloud()
        }
        alert.showSuccess("Priority", subTitle: "Please choose the priority")
        print("test if upload success 2")
        print("test if upload success 3")
    }
    
    
    func save_task_status_to_cloud()
    {
        print("save priority to the cloud")
        Database.fetch(withRecordID: recordID!) { (record, error) in
            if(error != nil)
            {
                print("error is nil")
            }
            else
            {
                record?["status"] = self.taskStatus as CKRecordValue?
                self.Database.save(record!, completionHandler: { (ckrcord, error) in
                    if error == nil
                    {
                        print("error is nil")
                    }})
                
            }
            
        }
        
    }
    
    
    @IBOutlet weak var Duration_outlet: UILabel!
    
    @IBAction func duration_slider(_ sender: Any) {
        
        
        var time = Int((sender as! UISlider).value)
        self.task_duration = time
        Duration_outlet.text =  String(time) + "Mins"
    
    }
    
    
    
    
    
    @IBAction func saveRecord(_ sender: Any) {
        
        print("save duration to the cloud")
        Database.fetch(withRecordID: recordID!) { (record, error) in
            if(error != nil)
            {
                print("error is nil")
            }
            else
            {
                record?["duration"] = self.duration.text as CKRecordValue?
                self.Database.save(record!, completionHandler: { (ckrcord, error) in
                    if error == nil
                    {
                        print("error is nil")
                    }})
                
            }
            
        }

    }
    

    @IBAction func Status(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )
        
        
        let status_alertview = SCLAlertView(appearance:appearance)
        
        status_alertview.addButton("Finished") {
            self.taskStatus  = 1
            self.save_task_status_to_cloud()
        }
        status_alertview.addButton("Not finished") {
            self.taskStatus = 2
            self.save_task_status_to_cloud()
        }
        
        status_alertview.showSuccess("Status", subTitle: "Please choose status")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "countDownSegue"
        {
            let cdsvc = segue.destination as! CountDownViewController
            cdsvc.count_down_seconds = self.task_duration
            let temp = cdsvc.popoverPresentationController
            //
            
            let minimumSize = cdsvc.view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
            cdsvc.preferredContentSize = CGSize(width: self.view.bounds.width/2, height: minimumSize.height)
         
            print("the cdsvc.count_down_seconds is \(cdsvc.count_down_seconds)")
            temp?.delegate = self
            
        }
        
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.overFullScreen
    }
    
    func presentationController(_ controller: UIPresentationController, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
        let navcon =  UINavigationController(rootViewController: controller.presentedViewController)
        
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style:.extraLight))
        
        visualEffect.frame = navcon.view.bounds
        navcon.view.insertSubview(visualEffect, at: 0)
        
        return navcon
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}
