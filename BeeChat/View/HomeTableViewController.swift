//
//  HomeTableViewController.swift
//  BeeChat
//
//  Created by Nihas Yousuf on 2023-02-05.
//

import UIKit
import FirebaseAuth
class HomeTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: ConstCurrentUser)
            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome") as! UIViewController
            story.modalPresentationStyle = .fullScreen
            self.present(story, animated: true)
        }catch{
            
        }
    }
    
}
