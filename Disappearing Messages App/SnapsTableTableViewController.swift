//
//  SnapsTableTableViewController.swift
//  Snapchat Clone
//
//  Created by Andranik Karapetyan on 12/17/20.
//  Copyright © 2020 Andranik Karapetyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableTableViewController: UITableViewController
{
    var snaps : [DataSnapshot] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        if let currentUserUID = Auth.auth().currentUser?.uid
        {
            Database.database().reference().child("users").child(currentUserUID).child("snaps").observe(.childAdded, with: { (snapshot) in
                
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                
                
                Database.database().reference().child("users").child(currentUserUID).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    
                    var index = 0
                    for snap in self.snaps
                    {
                        if snapshot.key == snap.key
                        {
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                    
                })
            })

        }
        
    }

    @IBAction func LogOutTapped(_ sender: Any)
    {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if snaps.count == 0
        {
            return 1
        }
        else
        {
            return snaps.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        if snaps.count == 0
        {
            cell.textLabel?.text = "You have no snaps 😔"
        }
        else
        {
            let snap = snaps[indexPath.row]
            
            if let snapDictionary = snap.value as? NSDictionary
            {
                if let fromEmail = snapDictionary["from"] as? String
                {
                    cell.textLabel?.text = fromEmail
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let snap = snaps[indexPath.row]
        
        performSegue(withIdentifier: "ViewSnapSegue", sender: snap)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "ViewSnapSegue"
        {
            if let viewVC = segue.destination as? ViewSnapViewController
            {
                if let snap = sender as? DataSnapshot
                {
                    viewVC.snap = snap
                }
            }
        }
    }
}
