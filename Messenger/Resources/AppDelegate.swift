//
//  AppDelegate.swift
//  Messenger
//
//  Created by Sahil Kumar Bansal on 28/10/21.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn
//import GIDSignIn
//import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate  {
    
    
    
    
func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
    FirebaseApp.configure()
    ApplicationDelegate.shared.application(
        application,
        didFinishLaunchingWithOptions: launchOptions
    )
    
    
    return true
}
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        guard error ==  nil else {
//            if let error = error{
//                print("failed to sign in with google\(error)")}
//            return
//        }
//        guard let authentication = user.authentication else {return}
//        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                       accessToken: authentication.accessToken)
//        
//        
//    }
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        print("Google user was disconnected")
//    }
func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
) -> Bool {
    ApplicationDelegate.shared.application(
        app,
        open: url,
        sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
        annotation: options[UIApplication.OpenURLOptionsKey.annotation]
    )
//    return GIDSignIn.sharedInstance().handle(url, sourceApplication: "", annotation: "")
    
}
}





