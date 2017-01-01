//
//  TwitterCloudTableViewController.swift
//  PostMessage
//
//  Created by System Administrator on 12/24/16.
//  Copyright © 2016 yangzhiqiong. All rights reserved.
//

import UIKit
import CloudKit

class TwitterCloudTableViewController: UITableViewController {

    
    var messages = [CKRecord]()
    {
        didSet
        {
            self.tableView.reloadData()
        
        }
    
    }
    var refresh:UIRefreshControl!
    
    private let subscriptionID = "All QandA Creations and Deletions"
    
    private var cloudkitObserver:NSObjectProtocol?
    
    let DataBase =  CKContainer.default().publicCloudDatabase

    
    @IBAction func sendMessage(_ sender: Any) {
        
        let alert = UIAlertController(title: "New Message", message: "Enter a Message", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "your message"
        }
        
        alert.addAction(UIAlertAction(title: "send", style: .default, handler: { (action) in
            let textfield = alert.textFields!.first!
            
            if  textfield.text != ""
            {
                let newMessage = CKRecord(recordType: "Message")
                newMessage["content"] = textfield.text as CKRecordValue?
                let publicData = self.DataBase
                publicData.save(newMessage, completionHandler: { (record, error) in
                if error == nil
                {
                    DispatchQueue.main.async {
                    //    self.tableView.beginUpdates()
                        self.messages.append(newMessage)
                       // let indexPath = IndexPath(row: 0, section: 0)
                     //   self.tableView.insertRows(at: [indexPath], with: .top)
                      //  self.tableView.endUpdates()
                        //self.tableView.reloadData()
                    }
                    
                    
                }
                else
                {
                    print(error ?? "error")
                }

                })
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
 
    }

    
    
    func loadData()
    {
        print("load data\n")
        
        messages = [CKRecord]()
        
        let publicData =  self.DataBase
        let query = CKQuery(recordType: "Message", predicate: NSPredicate(format: "TRUEPREDICATE"))
        
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        publicData.perform(query, inZoneWith: nil) { (results, error) in
            
            if let records = results
            {
                print("the number of result is \(records.count)\n")
                print(records)
                self.messages = records
                DispatchQueue.main.async {
                    print("load data and refresh tableView")
                    //self.tableView.reloadData()
                    self.refresh.endRefreshing()
            }
            }

        }

    
    }
    
    
    func setupCloudkitNotification()
    {
        let privateDataBase =  self.DataBase
        
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let subscription  = CKQuerySubscription(recordType: "Message", predicate: predicate, options: [.firesOnRecordCreation,.firesOnRecordDeletion,.firesOnRecordUpdate])
        
        let notificationInfo = CKNotificationInfo()
        
        notificationInfo.alertBody = "a New Message was added"
        notificationInfo.shouldBadge = true
        
        subscription.notificationInfo = notificationInfo
     //   subscription.subscriptionID = self.subscriptionID
        
        privateDataBase.save(subscription) { (returnRecord, error) in
            
            if let err = error
            {
                print("suscription failed %@",err.localizedDescription)
            
            }
            else
            {
                    print("success to suscribe")
            
            }
        }
    
        
    cloudkitObserver = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "cloudKitNotification"), object: nil, queue: OperationQueue.main, using: { (notification) in
        if let ckqn = notification.userInfo?["info"] as? CKQueryNotification
        {
            print("get notifications")
            print("the ckqn is \(ckqn)")
            self.icloudHandleSuscriptioNotification(ckqn: ckqn)
        }
    })
        
        
    }
    
    
    func icloudHandleSuscriptioNotification(ckqn:CKQueryNotification)
    {
        print("handle notifications,the record is is \(ckqn.recordID)")

            if let recordID = ckqn.recordID
            {
                switch ckqn.queryNotificationReason {
                case .recordCreated:
                    print("get record created the record id is \(recordID)\n")
                    DataBase.fetch(withRecordID: recordID, completionHandler: { (record, error) in
                        if record != nil
                        {
                           // DispatchQueue.main.async {
                                self.messages = (self.messages + [record!])
                               // self.tableView.reloadData()
                        //    }
                        
                        }
                        else
                        {
                            
                            print("record is nil the error is \(error)")
                            
                        }
                    })
                    break;
                case .recordDeleted:
                    print("get record deleted")
                    //DispatchQueue.main.sync {
                        print("bbkkkkk")
                   self.messages = self.messages.filter{$0.recordID != recordID}
                 //  self.tableView.reloadData()
              // }
                break;
                default:
                break;
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "pull and load data")
        refresh.addTarget(self, action: #selector(loadData), for: .valueChanged)
        self.tableView.addSubview(refresh)
    
        setupCloudkitNotification()

        loadData()
        

     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        print("message.counts is \(messages.count)")
        return messages.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! toDoItemTableViewCell
        
        if messages.count == 0
        {
            return cell
        }
        
       let message = messages[indexPath.section]
    
        
       if let messageContent = message["content"]        {
            let dateFormat =  DateFormatter()
            dateFormat.dateFormat = "MM/dd/yyyy hh-mm-ss"
            let dateString = dateFormat.string(from: message.creationDate!)
        
            cell.taskDate.text = dateString
            cell.taskDate.textAlignment = .left
            cell.taskDate.borderStyle = .none
            cell.TaskTitle.text = messageContent as! String
            cell.TaskTitle.textAlignment = .center
            cell.TaskTitle.isUserInteractionEnabled = false
            cell.priorityImageView.image = UIImage(named: "tomato.jpg")
           // cell.priorityImageView.sizeToFit()

       }
        
    //  let priority = message["priority"] as! Int
    
      //  print("the priority is \(priority)")
      

      return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let recordId = self.messages[indexPath.section].recordID
        
        if editingStyle == .delete
        {
            self.DataBase.delete(withRecordID: recordId, completionHandler: { (recordid, error) in
                if error == nil
                {
                  //  self.tableView.deleteRows(at: [indexPath], with: .fade)
                    print("fail to delete record is from the database")
                    self.messages.remove(at: indexPath.row)
                // self.tableView.reloadData()
                }
            })
        
        
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let indexpath = self.tableView.indexPathForSelectedRow
        
        if segue.identifier == "todoListItem"
        {
           // let message = self.messages[(indexpath?.section)!]
            let tdvc = (segue.destination as! UINavigationController).visibleViewController as! ToDoItemViewController
            tdvc.savetype = 1
            print("the record type is \(tdvc.savetype)")
            tdvc.recordID = self.messages[(indexpath?.section)!].recordID
           // tdvc.todoitemName = message["content"] as! String?
            
        
       }
        else if segue.identifier == "addTodoItem"
        {
             let tdvc = (segue.destination as! UINavigationController).visibleViewController as! ToDoItemViewController
            tdvc.savetype = 2
            print("the record type is \(tdvc.savetype)")
        
        }
        
    }
    
    
    
    

}
