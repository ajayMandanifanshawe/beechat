//
//  ProfileViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-05.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var usernumber: UILabel!
    @IBOutlet weak var usermail: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatarimg: UIImageView!
    @IBOutlet weak var banner: UIView!
    var user:User? = nil
    override func viewDidLoad() {
        super.viewDidLoad()

        if let user = user{
            usernumber.text = user.phoneNumber
            usermail.text = user.email
            username.text = user.username
            status.text = user.status
            if (user.profileImg == "")
            {
                avatarimg.image = UIImage(systemName: "person.circle.fill")
            }else{
                
            }
        }

    }
    


    @IBAction func startchatbtn(_ sender: UIButton) {
        
       let chatroomid =  startchat(user1: User.currentUser!, user2: user!)
        
        let privatChatView = MessageViewController(chatId: chatroomid,recepientId: user?.id ?? "",recepientName: user?.username ?? "")
        privatChatView.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(privatChatView, animated: true)
    }
}
