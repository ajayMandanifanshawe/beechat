//
//  EditUserInfoTableViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-06.
//

import UIKit
import ProgressHUD
import Gallery
class EditUserInfoTableViewController: UITableViewController {

    @IBOutlet weak var profileimg: UIImageView!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var gallery:GalleryController!
    override func viewDidLoad() {
        super.viewDidLoad()
        profileimg.layer.cornerRadius = profileimg.frame.size.height/2
        profileimg.clipsToBounds = true
        profileimg.contentMode = .scaleToFill
        
        if let user = User.currentUser{
            
            if(user.profileImg != "")
            {
                Filestorage.downloadImageUrl(imageurl: user.profileImg) { img in
                    DispatchQueue.main.async {
                        self.profileimg.image = img
                    }
                    
                }
            }else{
                self.profileimg.image = UIImage(systemName: "person.circle.fill")
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }
    
    
    @IBAction func updateimagebtn(_ sender: UIButton) {
      
        showgalleryedit()
        
    }
    
    
    func showgalleryedit(){
    
        gallery = GalleryController()
        gallery.delegate = self
        Config.tabsToShow = [.cameraTab,.imageTab]
        Config.Camera.imageLimit = 1
        Config.initialTab = .imageTab
        
        gallery.modalPresentationStyle = .fullScreen
        self.present(gallery, animated: true)
    }
    
    @IBAction func saveBtnClicked(_ sender: Any) {
        
        if usernameTextField.text != ""
        {
            if var user = User.currentUser{
                user.username = usernameTextField.text!
                user.phoneNumber = phoneNumberTextField.text!
                saveUserLocally(user: user)
                FirebaseUser.shared.saveUserOnFirebase(user: user)
                ProgressHUD.showSucceed("Saved")
            }
        }else{
            ProgressHUD.showFailed("username is required")
        }
        
        
    }
    
    func updateUI(){
        if let user = User.currentUser{
            usernameTextField.text = user.username
            
            if user.phoneNumber  == "no phone number specified"
            {
                phoneNumberTextField.text = ""

            }else{
                phoneNumberTextField.text = user.phoneNumber

            }
            
         
            
            
            
        
        }else{
            print("no info")
        }
    }
  
    func uploadAvatarImage(image:UIImage)
    {
        DispatchQueue.main.async {
            self.profileimg.image = image

        }
        
        let fileDirec = "Avatars/"+"_\(User.currentId)"+".jpeg"
        Filestorage.uploadImage(image, directory: fileDirec) { documentLink in
            if var user = User.currentUser{
                user.profileImg = documentLink ?? ""
                saveUserLocally(user: user)
                FirebaseUser.shared.saveUserOnFirebase(user: user)
                FirebaseUser.shared.saveImageOnRecent(imageurl: documentLink ?? "")
                
            }
            Filestorage.savefilelocally(filedata: image.jpegData(compressionQuality: 1)! as NSData, filename: User.currentId)
            
        }
        
        
     
        
        
    }
   
}

extension EditUserInfoTableViewController: GalleryControllerDelegate{
    func galleryController(_ controller: Gallery.GalleryController, didSelectImages images: [Gallery.Image]) {
        
        if images.count>0{
           let img = images.first!
            img.resolve { myimage in
                
                if let myimage = myimage{
                    self.uploadAvatarImage(image: myimage)
                   
                }
                
            }
        }
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, didSelectVideo video: Gallery.Video) {
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: Gallery.GalleryController, requestLightbox images: [Gallery.Image]) {
        controller.dismiss(animated: true)
    }
    
    func galleryControllerDidCancel(_ controller: Gallery.GalleryController) {
        controller.dismiss(animated: true)
    }
    
    
}
