//
//  ProfileViewController.swift
//  Messenger
//
//  Created by Sahil Kumar Bansal on 28/10/21.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
class ProfileViewController: UIViewController {

    var data = ["Log Out"]
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    

   

}
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alert = UIAlertController(title: "Wanna Log Out?",
                                      message: "",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Log  Out", style: .destructive, handler: {[weak self] _
            in
            guard let strongSelf = self else{
                return
            }
            //log out facebook
            FBSDKLoginKit.LoginManager().logOut()
            //log out google
            GIDSignIn.sharedInstance.signOut()
            
            do{
                try FirebaseAuth.Auth.auth().signOut()
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav,animated: true)
            }
            catch{
                print("Failed to LogOut")
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert,animated: true)
       
    }
}
