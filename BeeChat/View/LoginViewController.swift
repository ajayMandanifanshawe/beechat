//
//  LoginViewController.swift
//  BeeChat
//
//  Created by Nihas Yousuf on 2023-02-05.
//

import UIKit
import ProgressHUD
class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func loginBtn(_ sender: Any) {
        if(emailTextField.text != "" && passwordTextField.text != "")
        {
            FirebaseUser.shared.signin(email: emailTextField.text!, password: passwordTextField.text!) { error in
                if error == nil {
                    ProgressHUD.showSucceed("SignIn Succcessful")
                    self.LoadHome()
                }else{
                    ProgressHUD.showFailed(error!.localizedDescription)

                }
            }
        }else
        {
            ProgressHUD.showFailed("Please insert in all the fields!!")
        }
    }
    
    @IBAction func registertwoBtn(_ sender: Any) {
    }
    
    func LoadHome()
    {
        let story = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "home") as! UITabBarController
        story.modalPresentationStyle = .fullScreen
        self.present(story, animated: true)
    }
    
}
