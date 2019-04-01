//
//  SignInViewController.swift
//  MyLyrics
//
//  Created by Mudith Chathuranga on 3/18/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    @IBOutlet weak var loadingMain: UIView!
    
    @IBOutlet weak var useremail: UITextField!
    @IBOutlet weak var password: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //GIDSignIn.sharedInstance().signIn()
        // Do any additional setup after loading the view.
         addToolBar()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                // ...
                print(error)
                let alert = UIAlertController(title: "Login Error!", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            AppData.storeData(data: authResult!.user.displayName , key: UserData.username.rawValue)
            self.dismiss(animated: true, completion: nil)
            print(authResult!.user.email!)
            print(authResult!.user.displayName)
            // User is signed in
            // ...
        }

    }
    
    @IBAction func userCustomLogin(_ sender: Any) {
        self.showLoading()
        Auth.auth().signIn(withEmail: self.useremail.text!, password: self.password.text!) { [weak self] user, error in
            guard let strongSelf = self else { return }
            strongSelf.hideLoading()
            if error != nil {
                let alert = UIAlertController(title: "Login Error!", message: error?.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                strongSelf.present(alert, animated: true, completion: nil)
            } else {
                AppData.storeData(data: user!.user.displayName , key: UserData.username.rawValue)
                strongSelf.dismiss(animated: true, completion: nil)
               
            }

            // ...
        }
    }
    
    func showLoading() {
        self.loadingMain.alpha = 1.0
        self.view.bringSubviewToFront(self.loadingMain)
    }
    
    func hideLoading() {
        self.loadingMain.alpha = 0
        self.view.sendSubviewToBack(self.loadingMain)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func  addToolBar(){
       
        let toolbarStatus = UIToolbar ()
        toolbarStatus.sizeToFit()
        
        let clearButton = UIBarButtonItem(title: "Clearn", style: .plain , target: nil, action: #selector(clerDone))
        
        let doneStatusButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneSelect))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace
            , target: nil, action: nil)
        toolbarStatus.setItems([clearButton,spaceButton,doneStatusButton], animated: false)
        
        self.useremail.inputAccessoryView = toolbarStatus
        
    }
    
    @objc func clerDone (){
    self.useremail.text = ""
    }
    
    @objc func doneSelect (){
        self.view.endEditing(true)
    }
}
extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            self.password.becomeFirstResponder()
        }else if textField.tag == 2 {
            self.view.endEditing(true)
            self.userCustomLogin((UIButton()))
        }
        return true
    }
    
}
