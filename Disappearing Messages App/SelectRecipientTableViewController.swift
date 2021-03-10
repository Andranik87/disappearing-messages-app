//
//  SelectRecipientTableViewController.swift
//  Snapchat Clone
//
//  Created by Andranik Karapetyan on 12/17/20.
//  Copyright © 2020 Andranik Karapetyan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SelectRecipientTableViewController: UITableViewController
{

    var snapDescription = ""
    var downloadURL = ""
    var users : [User] = []
    var imageName = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            
            let user = User()
            if let userDictionary = snapshot.value as? NSDictionary
            {
                if let email = userDictionary["email"] as? String
                {
                    user.email = email
                    user.UID = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = users[indexPath.row]

        if let fromEmail = Auth.auth().currentUser?.email
        {
            let snap = ["from":fromEmail, "description":snapDescription, "imageURL":downloadURL, "imageName":imageName]
            
            Database.database().reference().child("users").child(user.UID).child("snaps").childByAutoId().setValue(snap)
            
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

class User
{
    var email = ""
    var UID = ""
}
