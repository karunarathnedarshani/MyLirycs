//
//  LandingViewController.swift
//  MyLyrics
//
//  Created by Mudith Chathuranga on 3/18/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class LandingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppTempData.userHandle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // ...
            if user == nil {
                self.performSegue(withIdentifier: "showLogin", sender: nil)
            } else {
                self.performSegue(withIdentifier: "showHome", sender: nil)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(AppTempData.userHandle!)
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
