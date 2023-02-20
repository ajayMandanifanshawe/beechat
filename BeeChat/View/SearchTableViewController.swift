//
//  SearchTableViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-19.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating {
    var allusers: [User] = []
    var filteredUser: [User] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the search controller
        title = "Search"
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search..."
        navigationItem.searchController = searchController
        definesPresentationContext = true

        downloadAllUser()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isSearchBarEmpty() {
            return allusers.count
        } else {
            return filteredUser.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell", for: indexPath) as! SearchTableViewCell
        
        // Checks the search field and based on that shows the list table
        if isSearchBarEmpty() {
            let singleUser = allusers[indexPath.row]
            cell.configUserCell(user: singleUser)
        } else {
            let singleUser = filteredUser[indexPath.row]
            cell.configUserCell(user: singleUser)
        }
        return cell
    }

    func downloadAllUser() {
        FirebaseUser.shared.getAllUser { alluser in
            self.allusers = alluser
            self.tableView.reloadData()
        }
    }

    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        filterContentForSearchText(searchText)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredUser = allusers.filter { (user: User) -> Bool in
            user.username.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func isSearchBarEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
}
