//
//  SearchTableViewCell.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-19.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarimage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configUserCell(user:User)
    {
        emailLabel.text = user.email
        nameLabel.text = user.username
        if(user.profileImg == "")
        {
            avatarimage.image = UIImage(systemName: "person.circle.fill")
        }else{
            
        }
    }

}
