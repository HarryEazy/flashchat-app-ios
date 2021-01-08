//
//  ChatViewController.swift
//  Flash Chat iOS13
//


import UIKit
import Firebase

class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    
    // reference to database
    let db = Firestore.firestore()
    
    // array of messages structs
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // it will trigger the methods it needs from chatviewcontroller
        tableView.dataSource = self
        // hide back button as its not needed, we have log out button instead
        navigationItem.hidesBackButton = true
        // set title
        title = K.appName
        
        // register table view for xib
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        // call load messages function
        loadMessages()
        
        
    }
    
    func loadMessages() {
        
        db.collection(K.FStore.collectionName)
            // order collection in db by date
            .order(by: K.FStore.dateField)
            // add listner 
            .addSnapshotListener { (querySnapshot, error) in
            
            // clear array to avoid dupiclates
            self.messages = []
            
            if let e = error {
                print("There was an issue retrieving data from Firstore. \(e)")
            } else {
                if let snapShotDocuments =  querySnapshot?.documents {
                    // data back from firebase is Any as it allows users to store multiple forms of data in db
                    // loop through array
                    for doc in snapShotDocuments {
                        // get data
                        let data = doc.data()
                        // downcast into Strings
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String{
                            // create a message
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            // as we are in closure need to use DispatchQueue to get main thread
                            DispatchQueue.main.async {
                                // reload daa for table view to display data
                                self.tableView.reloadData()
                                // constant for index path to get last index
                                let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                                // scroll to specified index, at is where the row should be positioned
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        
        // get message of user
        // get user email
        if let messageBody = messageTextfield.text,  let messageSender = Auth.auth().currentUser?.email {
            // add data to database
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                // get time of message to store in db and to sort according to time
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    print("There was an issue saving data to Firestore, \(e)")
                } else {
                    print("Successfully saved data")
                    
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                    
                }
            }
        }
        
        
    }
    
    // method to sign out users
    @IBAction func logOutButtonPressed(_ sender: UIBarButtonItem) {
        
        // throws exceptions so must be wrapped in do try block
        do {
            try Auth.auth().signOut()
            // directs to root VC
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
    }
    
}

// this is the protocol responsible for populating the table view
extension ChatViewController: UITableViewDataSource {
    
    // method to specify number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // returns array length as number of rows to use
        return messages.count
    }
    
    // method wants to know what UITableView it needs to display
    // will call method for each row - we put the prototype K.cellIdentifier as the first arg
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messages[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        // indexPath.row gives current row number
        cell.label.text = message.body
        
        // this is a message from the current user
        if message.sender == Auth.auth().currentUser?.email {
            // hide the left image view from screen if message is from current user
            cell.leftImageView.isHidden = true
            // make sure right image is visible
            cell.rightImageView.isHidden = false
            // set background color - to use custom UIColor need to use function
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            // change label color
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
            
        // this is a message from another sender
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
       
        return cell
    }
    
    
    
}
