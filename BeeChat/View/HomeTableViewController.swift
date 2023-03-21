//
//  HomeTableViewController.swift
//  BeeChat
//
//  Created by Nihas Yousuf on 2023-02-05.
//

import FirebaseAuth
import UIKit

import FirebaseAuth
import UIKit
class HomeTableViewController: UITableViewController {
    var allLatest: [RecentChat] = []
    var filteredLatest: [RecentChat] = []
    let searchContollers = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        donwloadAlldata()
    }
    
    private func donwloadAlldata() {
        FirebaseLatestListener.shared.downloadAllLatestfromfirestore { latest in
            if let latest = latest {
                self.allLatest = latest
               
            } else {
                self.allLatest = []
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
  
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return  allLatest.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! RecentChatTableViewCell
        
        cell.config(recentChat: allLatest[indexPath.row])

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recent = allLatest[indexPath.row]
        
        FirebaseLatestListener.shared.clearunreadCounter(recent: recent)
        gotochat(recent: recent)
    }

    func gotochat(recent: RecentChat) {
        restartChat(chartRoomId: recent.chatRoomId, memeberIds: recent.memeberIds)
        let privatChatView = MessageViewController(chatId: recent.chatRoomId, recepientId: recent.receiverId, recepientName: recent.receiverName)
        privatChatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privatChatView, animated: true)
    }

    @IBAction func logout(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: ConstCurrentUser)
            let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
            story.modalPresentationStyle = .fullScreen
            present(story, animated: true)
        } catch {}
    }
    
  
}
