//
//  ProfileSeetingsTableViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-06.
//

import UIKit
import FirebaseAuth

class ProfileSeetingsTableViewController: UITableViewController {

    @IBOutlet weak var mobileLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userProfileimage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2
        {
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

    
    func updateUI(){
        if let user = User.currentUser{
            nameLabel.text = user.username
            emailLabel.text = user.email
            mobileLabel.text = user.phoneNumber
            
            if user.profileImg == ""
            {
                userProfileimage.image = UIImage(systemName: "person.circle.fill")
            }else{
                
            }
        }else{
            print("no info")
        }
    }
  
    
  
    
    
}
