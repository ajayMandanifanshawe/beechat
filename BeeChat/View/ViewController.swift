//
//  ViewController.swift
//  BeeChat
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func registerBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "registersegue", sender: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "loginsegue", sender: nil)
        
    }
}

