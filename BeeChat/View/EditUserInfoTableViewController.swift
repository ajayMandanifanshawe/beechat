//
//  EditUserInfoTableViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-06.
//

import UIKit
import ProgressHUD
class EditUserInfoTableViewController: UITableViewController {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        if usernameTextField.text != ""
        {
            if var user = User.currentUser{
                user.username = usernameTextField.text!
                user.phoneNumber = phoneNumberTextField.text!
                saveUserLocally(user: user)
                FirebaseUser.shared.saveUserOnFirebase(user: user)
                ProgressHUD.showSucceed("Saved")
            }
        }else{
            ProgressHUD.showFailed("username is required")
        }
        
        
    }
    
    func updateUI(){
        if let user = User.currentUser{
            usernameTextField.text = user.username
            
            if user.phoneNumber  == "no phone number specified"
            {
                phoneNumberTextField.text = ""

            }else{
                phoneNumberTextField.text = user.phoneNumber

            }
            
        
        }else{
            print("no info")
        }
    }
  
    
   
}
