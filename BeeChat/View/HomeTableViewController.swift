//
//  HomeTableViewController.swift
//  BeeChat
//
//  Created by Nihas Yousuf on 2023-02-05.
//

import UIKit
import FirebaseAuth
class HomeTableViewController: UITableViewController, UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        filteredLatest = allLatest.filter { user -> Bool in
            let searchusercombined = "\(user.receiverName)"
            print(searchusercombined)

            return searchusercombined.lowercased().contains((searchController.searchBar.text)!.lowercased())
        }
        self.tableView.reloadData()
    }
    
    
    var allLatest:[RecentChat] = []
    var filteredLatest:[RecentChat] = []
    let searchContollers = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        donwloadAlldata()
       
        setupsearchcontroller()
    }
    
    
    func setupsearchcontroller()
    {
//        searchContollers.searchBar.searchTextField.backgroundColor = .darkGray
//        searchContollers.searchBar.barTintColor = .white
//        searchContollers.searchBar.searchTextField.tintColor = .white
//        searchContollers.searchBar.searchTextField.textColor = .white
        searchContollers.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search by name",attributes: [.foregroundColor:UIColor.lightGray])
        navigationItem.searchController = searchContollers
//        navigationItem.searchController?.searchBar.searchTextField.textColor = .white
        navigationItem.hidesSearchBarWhenScrolling = true
        searchContollers.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchContollers.searchResultsUpdater = self
    }
    
    
  
    
    private func donwloadAlldata()
    {
        FirebaseLatestListener.shared.downloadAllLatestfromfirestore { latest in
            if let latest = latest{
                self.allLatest = latest
               
            }else{
                self.allLatest = []
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchContollers.isActive ? filteredLatest.count : allLatest.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! RecentChatTableViewCell
        
        cell.config(recentChat: searchContollers.isActive ? filteredLatest[indexPath.row] : allLatest[indexPath.row])

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recent = searchContollers.isActive ? filteredLatest[indexPath.row] : allLatest[indexPath.row]
        
        FirebaseLatestListener.shared.clearunreadCounter(recent: recent)
        gotochat(recent:recent)

        
        
    }
    func gotochat(recent:RecentChat)
    {
        restartChat(chartRoomId: recent.chatRoomId, memeberIds: recent.memeberIds)
        let privatChatView = MessageViewController(chatId: recent.chatRoomId,recepientId: recent.receiverId,recepientName: recent.receiverName)
        privatChatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privatChatView, animated: true)
    }

    @IBAction func logout(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: ConstCurrentUser)
            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
            story.modalPresentationStyle = .fullScreen
            self.present(story, animated: true)
        }catch{
            
        }
    }

}
