//
//  ProfileViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-02-05.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var banner: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        banner.layer.cornerRadius = 20
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
