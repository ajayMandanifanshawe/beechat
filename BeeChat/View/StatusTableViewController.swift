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



}
