//
//  ViewSnapViewController.swift
//  Snapchat Clone
//
//  Created by Andranik Karapetyan on 12/17/20.
//  Copyright © 2020 Andranik Karapetyan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController
{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var snap: DataSnapshot?
    var imageName = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let snap = snap
        {
            if let snapDictionary = snap.value as? NSDictionary
            {
                if let description = snapDictionary["description"] as? String
                {
                    if let imageURL = snapDictionary["imageURL"] as? String
                    {
                        messageLabel.text = description
                        
                        if let URL = URL(string: imageURL)
                        {
                            imageView.sd_setImage(with: URL, completed: nil)
                        }
                        
                        if let imageName = snapDictionary["imageName"] as? String
                        {
                            self.imageName = imageName
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        if let currentUserUID = Auth.auth().currentUser?.uid
        {
            if let key = snap?.key
            {
                Database.database().reference().child("users").child(currentUserUID).child("snaps").child(key).removeValue()
                
                Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
            }
        }
    }
}
