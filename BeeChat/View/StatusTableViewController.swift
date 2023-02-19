//
//  StatusTableViewController.swift
//  BeeChat
//
//  Created by Nihas Yousuf on 2023-02-06.
//

import UIKit
import ProgressHUD
class StatusTableViewController: UITableViewController,UITextFieldDelegate {


    @IBOutlet weak var editStatusField: UITextField!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        editStatusField.delegate = self
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateview()
    }
    
    func updateview(){
        if let user = User.currentUser{
            statusMessage.text = user.status
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        if(editStatusField.text != "")
        {
            if var user = User.currentUser{
                user.status = editStatusField.text!
                saveUserLocally(user: user)
                FirebaseUser.shared.saveUserOnFirebase(user: user)
                ProgressHUD.showSucceed("Status Updated")
                updateview()
            }
        }
        return true
    }
    


}
