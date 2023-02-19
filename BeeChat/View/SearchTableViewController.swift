//
//  SearchTableViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-19.
//

import UIKit

class SearchTableViewController: UITableViewController {

    var allusers:[User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        downloadAllUser()
    }



    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allusers.count
    }

    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! SearchTableViewCell
        let singleUser = allusers[indexPath.row]
        cell.configUserCell(user: singleUser)
        return cell
        
    }
    
    func downloadAllUser(){
        FirebaseUser.shared.getAllUser { alluser in
            self.allusers = alluser
            self.tableView.reloadData()
        }
    }
}
