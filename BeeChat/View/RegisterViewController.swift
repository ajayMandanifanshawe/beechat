//
//  RegisterViewController.swift
//  BeeChat
//


import UIKit
import ProgressHUD
class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboard()
        
    }
    
    func setupKeyboard(){
        passwordTextField.delegate = self
        emailTextField.delegate = self
        nameTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillshow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillhide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    @objc func keyboardwillshow(sender:NSNotification){
      
        print("he")
        guard let userInfo = sender.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

        print(keyboardFrame)
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY + 50  > keyboardTopY {
            let textBoxY = convertedTextFieldFrame.origin.y
                let newFrameY = (textBoxY - keyboardTopY / 2) * -1
                view.frame.origin.y = newFrameY
        }

    
        
    }
    
    @objc func keyboardwillhide(sender:NSNotification){
        view.frame.origin.y = 0
        
    }
    

    @IBAction func RegisterBtnClicked(_ sender: UIButton) {
        
        if(passwordTextField.text != "" && emailTextField.text != "" && nameTextField.text != "")
        {
            FirebaseUser.shared.registerUser(email: emailTextField.text!, password: passwordTextField.text!, name: nameTextField.text!) { error in
                if error == nil {
                    ProgressHUD.showSucceed("Register Succcessful")
                    self.dismiss(animated: true)
                }else{
                    ProgressHUD.showFailed(error!.localizedDescription)

                }
            }
        }else
        {
            ProgressHUD.showFailed("Please insert in all the fields!!")
        }
        
    }
    
    @IBAction func loginScreenPressed(_ sender: UIButton) {
    }
    
    
    
}


extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    /// Finds the current first responder
    /// - Returns: the current UIResponder if it exists
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}
