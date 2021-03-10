//
//  SelectPictureViewController.swift
//  Snapchat Clone
//
//  Created by Andranik Karapetyan on 12/17/20.
//  Copyright © 2020 Andranik Karapetyan. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTestField: UITextField!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = ""

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }

    @IBAction func SelectPhotoTapped(_ sender: Any)
    {
        if imagePicker != nil
        {
            imagePicker!.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    @IBAction func CameraTapped(_ sender: Any)
    {
        if imagePicker != nil
        {
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let image = info[.originalImage] as? UIImage
        {
            imageView.image = image
            imageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextTapped(_ sender: Any)
    {
        // DELETE THIS FOR PRODUCTION
//        messageTestField.text = "Rip and tear... Until it is done!"
//        imageView.image = UIImage(imageLiteralResourceName: "1B2B63B9-6FB3-40FE-B851-D83D200EF08C")
//        imageAdded = true
        // DELETE THIS FOR PRODUCTION

        if let message = messageTestField.text
        {
            if imageAdded && message != ""
            {
                let storage = Storage.storage()
                let imagesFolder = storage.reference().child("images")
                
                if let image = imageView.image
                {
                    if let imageData = image.jpegData(compressionQuality: 1.0)
                    {
                        imageName = "\(NSUUID.init()).jpg"
                        imagesFolder.child(imageName).putData(imageData, metadata: nil) { (metadata, error) in
                            
                            if let error = error
                            {
                                self.presentAlert(alert: error.localizedDescription)
                            }
                            else
                            {
//                                storage.reference(withPath: "images/\(imageName)").downloadURL
//                                { (url, error) in
//                                    guard let downloadURL = url else{
//                                        return
//                                    }
//
//                                    if let error = error
//                                    {
//                                        self.presentAlert(alert: error.localizedDescription)
//                                    }
//                                    self.performSegue(withIdentifier: "SelectRecieverSegue", sender: downloadURL)
//                                }
                                
                                storage.reference().child("images/\(self.imageName)").downloadURL(completion:
                                { (url, error) in

                                    if let error = error
                                    {
                                        self.presentAlert(alert: error.localizedDescription)
                                    }
                                    else
                                    {
                                        if let downloadURL = url?.absoluteString
                                        {
                                            self.performSegue(withIdentifier: "SelectRecieverSegue", sender: downloadURL)
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
            else
            {
                presentAlert(alert: "You must provide an image and a message for yout snap.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let downloadURL = sender as? String
        {
            if let selectVC = segue.destination as? SelectRecipientTableViewController
            {
                selectVC.downloadURL = downloadURL
                selectVC.snapDescription = messageTestField.text!
                selectVC.imageName = imageName
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
}
