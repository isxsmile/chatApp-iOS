//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestoreInternal


class ChatViewController: UIViewController{
    
    let db=Firestore.firestore()
    
    var messages:[Message]=[]
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource=self
        navigationItem.hidesBackButton=true
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
        loadMessages()
    }
    
    func loadMessages()
    {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener{ querySnapshot, error in
            self.messages=[]
            if let e=error
            {
                print("the was an error in reading the data from the database\(e)")
            }else
            {
                if let snapshotDocuments=querySnapshot?.documents
                {
                    for doc in snapshotDocuments
                    {
                        let data=doc.data()
                        if let messageSender=data[K.FStore.senderField] as? String,let messageBody=data[K.FStore.bodyField] as? String
                        {
                            let newMessage=Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexpath=IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexpath, at: .top, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody=messageTextfield.text,let messageSender=Auth.auth().currentUser?.email
        {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField:messageSender,
                K.FStore.bodyField:messageBody,
                K.FStore.dateField:Date().timeIntervalSince1970
            ]) { error in
                if let e=error
                {
                    print("error in savin the data in the firestore\(e)")
                }else
                {
                    print("data was saved")
                    DispatchQueue.main.async {
                        self.messageTextfield.text="";
                    }
                
                }
            }
        }
    }
    
    @IBAction func LogOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            navigationController?.popViewController(animated: true)
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
}
extension ChatViewController:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message=messages[indexPath.row]
        
        let cell=tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! TableViewCell
        cell.label.text=message.body
        
        if message.sender==Auth.auth().currentUser?.email
        {
            cell.leftAvatar.isHidden=true
            cell.rightAvatar.isHidden=false
            cell.messageBubble.backgroundColor=UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor=UIColor(named: K.BrandColors.purple)
        }else
        {
            cell.leftAvatar.isHidden=false
            cell.rightAvatar.isHidden=true
            cell.messageBubble.backgroundColor=UIColor(named: K.BrandColors.purple)
            cell.label.textColor=UIColor(named: K.BrandColors.lightPurple)
        }
        return cell
    }
    
    
}
