//
//  LoginViewController.swift
//  Snapchat Clone
//
//  Created by Andranik Karapetyan on 12/16/20.
//  Copyright © 2020 Andranik Karapetyan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController
{
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var bottomButton: UIButton!
    
    var signUpMode = false
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func TopTapped(_ sender: Any)
    {
        if let email = emailTextField.text
        {
            if let password = passwordTextField.text
            {
                if signUpMode
                {
                    Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                        
                        if let error = error
                        {
                            self.presentAlert(alert: error.localizedDescription)
                        }
                        else
                        {
                            if let result = result
                            {                                Database.database().reference().child("users").child(result.user.uid).child("email").setValue(result.user.email)
                            }
                            self.performSegue(withIdentifier: "MoveToSnaps", sender: nil)
                        }
                    }
                }
                else
                {
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if let error = error
                        {
                            self.presentAlert(alert: error.localizedDescription)
                        }
                        else
                        {
                            self.performSegue(withIdentifier: "MoveToSnaps", sender: nil)
                        }
                    }
                }
            }
        }
    }
    
    func presentAlert(alert: String)
    {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func BottomTapped(_ sender: Any)
    {
        if signUpMode
        {
            signUpMode = false
            topButton.setTitle("Log In", for: .normal)
            bottomButton.setTitle("Switch to Sign Up", for: .normal)
        }
        else
        {
            signUpMode = true
            topButton.setTitle("Sign Up", for: .normal)
            bottomButton.setTitle("Switch to Log In", for: .normal)
        }
    }
}

