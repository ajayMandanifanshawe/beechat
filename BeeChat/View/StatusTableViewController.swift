//
//  StatusTableViewController.swift
//  BeeChat
//
//  Created by Nihas Yousuf on 2023-02-06.
//

import UIKit

class StatusTableViewController: UITableViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var statusMessage: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        statusMessage.text = ""

        updateview()
    }
    
    func updateview(){
        if let user = User.currentUser{
            statusMessage.text = user.status
        }
    }



}
