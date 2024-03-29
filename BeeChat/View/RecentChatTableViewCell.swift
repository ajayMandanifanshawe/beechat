//
//  RecentChatTableViewCell.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-14.
//

import UIKit

class RecentChatTableViewCell: UITableViewCell {

    @IBOutlet weak var unreadLabek: UILabel!
    @IBOutlet weak var dateLabe: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var reciverNamelabel: UILabel!
    @IBOutlet weak var imageChat: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(recentChat:RecentChat){
        
        imageChat.layer.cornerRadius = imageChat.frame.size.height/2
        imageChat.clipsToBounds = true
        imageChat.contentMode = .scaleToFill
        
        reciverNamelabel.text = recentChat.receiverName
        message.text = recentChat.lastMessage
        if recentChat.avatarLink == ""{
            imageChat.image = UIImage(systemName: "person.circle.fill")
            
        }else{
            Filestorage.downloadImageUrl(imageurl: recentChat.avatarLink) { img in
                DispatchQueue.main.async {
                    self.imageChat.image = img
                }
                
            }
        }
        
        if recentChat.unreadCounter > 0{
            unreadLabek.isHidden = false
            unreadLabek.text = "\(recentChat.unreadCounter)"
        }else{
            unreadLabek.isHidden = true
        }
        
        dateLabe.text = timeelapsed(recentChat.date ?? Date())
    }

}
