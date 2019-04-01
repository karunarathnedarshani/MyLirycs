//
//  HomeViewController.swift
//  MyLyrics
//
//  Created by Mudith Chathuranga on 3/21/19.
//  Copyright © 2019 chathuranga. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import Alamofire
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    var ref: DatabaseReference!
    var singerList: [Singer] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerCell()
        self.ref = Database.database().reference()
        self.getSingerList()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self
        self.userName.text = AppData.getData(key: UserData.username.rawValue)
    }
  
    
    func registerCell() {
        self.tableView.register(UINib(nibName: "SingerTableViewCell", bundle: nil), forCellReuseIdentifier: "SingerTableViewCell")
    }
    
    @IBAction func LogOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    func getSingerList() {
        self.showActivity()
        
        self.ref.child("singers").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            //let singersList = value!
            print(value!)
            var singers: [Singer] = []

            if snapshot.childrenCount > 0 {
                for singer in snapshot.children.allObjects as! [DataSnapshot] {
                    //getting values
                    let singerObject = singer.value as? [String: AnyObject]
                    let singer = Singer(singerID: singerObject!["id"] as! String,
                                        singerName: singerObject!["name"]  as! String,
                                        singerNameSin: singerObject!["name_sin"]  as! String,
                                        singerImageURL: singerObject!["singer_img"]  as! String
                    )
                    singers.append(singer)
                }
            }
            self.singerList = singers
            self.tableView.reloadData()
            self.hideActivity()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func downloadImage(imageURL: String, ID: String) {
        Alamofire.request(imageURL, method: .get)
            .validate()
            .responseData(completionHandler: { (responseData) in
                switch responseData.result {
                case .success:
                    let item = self.singerList.filter{$0.singerID == ID}.first
                    item?.singerImage = UIImage(data: responseData.data!)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                case .failure:
                    
                    let item = self.singerList.filter{$0.singerID == ID}.first
                    item?.singerImage = UIImage(named: "loadingImg")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            })
    }
    
    func showActivity() {
        self.view.bringSubviewToFront(self.activityInd)
        self.activityInd.startAnimating()
    }
    
    func hideActivity() {
        self.view.sendSubviewToBack(self.activityInd)
        self.activityInd.stopAnimating()
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.singerList.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SingerTableViewCell", for: indexPath) as! SingerTableViewCell
        cell.singerEnglishName.text = self.singerList[indexPath.row].singerName
        cell.singerSinhalaName.text = self.singerList[indexPath.row].singerNameSin
        //if self.singerList[indexPath.row].singerImage != nil {
            //cell.singerImage.image = self.singerList[indexPath.row].singerImage!
        let url = URL(string: self.singerList[indexPath.row].singerImageURL)
        cell.singerImage.kf.setImage(with: url)
//        } else {
//            if !self.singerList[indexPath.row].userImageLoading {
//                self.singerList[indexPath.row].userImageLoading = true
//                self.downloadImage(imageURL: self.singerList[indexPath.row].singerImageURL, ID: self.singerList[indexPath.row].singerID)
//            }
//            cell.singerImage.image = UIImage(named: "loadingImg")
//        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "singerInfo", sender: nil)
        
    }
    
    
    
}
