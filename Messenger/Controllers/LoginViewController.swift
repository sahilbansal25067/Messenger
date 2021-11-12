//
//  LoginViewController.swift
//  Messenger
//
//  Created by Sahil Kumar Bansal on 28/10/21.
//

import UIKit
import FirebaseAuth
//import FacebookCore
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import JGProgressHUD
class LoginViewController: UIViewController  {
    private let spinner = JGProgressHUD(style: .dark)
    private let fbloginButton : FBLoginButton = {
       let button = FBLoginButton()
        button.permissions = ["email","public_profile"]
        return button
    }()
    private let scrollView : UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    private let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
        
    }()
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        
        return field
        
    }()
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds =  true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    private let googleLogInButton : GIDSignInButton = {
        let button = GIDSignInButton()
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance()?.presentingViewController = self
//        GIDSignIn.sharedInstance()?.delegate = self
        
        view.backgroundColor = .white
        title = "Log In"
        emailField.delegate = self
        passwordField.delegate = self
        fbloginButton.delegate = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        googleLogInButton.addTarget(self,
                                    action: #selector(googleButtonTapped)
                                    , for: .touchUpInside)
        
        
        //add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        scrollView.addSubview(fbloginButton)
        
        scrollView.addSubview(googleLogInButton)
        
        
        //google sign in
        
        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20 ,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                  y: emailField.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        loginButton.frame = CGRect(x: 30,
                                   y: passwordField.bottom + 10,
                                   width: scrollView.width - 60,
                                   height: 52)
        fbloginButton.frame = CGRect(x: 30,
                                   y: loginButton.bottom + 10,
                                   width: scrollView.width - 60,
                                     height: fbloginButton.height)
        googleLogInButton.frame = CGRect(x: 30,
                                   y: fbloginButton.bottom + 10,
                                   width: scrollView.width - 60,
                                     height: fbloginButton.height)
//        fbloginButton.center = scrollView.center
//        fbloginButton.frame.origin.y = loginButton.bottom + 20
    }
    @objc private func googleButtonTapped()
    {
     
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in

          if let error = error {
           
            return
          }

          guard
            let authentication = user?.authentication,
            let idToken = authentication.idToken
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: authentication.accessToken)
            guard let email = user?.profile?.email,
                  let firstName = user?.profile?.givenName,
                  let lastName = user?.profile?.familyName else{
                      return
                      }
            DatabaseManager.shared.userExists(with: email, completion: {exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailAddress: email))
                }
            })


            FirebaseAuth.Auth.auth().signIn(with: credential) {[weak self] authResult, error in
                guard let strongSelf = self else {return}
                guard let _ = authResult, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed \(error)")
                    }
                   
                    return
                }
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
            print(credential)
        }
          
            
          
        
    }
    @objc private func loginButtonTapped(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count>=6 else
        {
            alertUserLoginError()
            return
        }
        spinner.show(in: view)
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self]
            authResult, error in
            guard let strongSelf = self else {return}
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            guard let result = authResult , error == nil else
            {
                return
            }
            let user = result.user
            print("Logged In user:\(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    func alertUserLoginError(){
        let alert = UIAlertController(title: "Woops",
                                      message: "Please Enter all information to login",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert,animated: true)
    }
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title =  "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

    

}
extension LoginViewController : UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField
        {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField
        {
            loginButtonTapped()
        }
        return true
    }
}
extension LoginViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        guard  let token = result?.token?.tokenString else {
            print("User failed to login with facebook")
            return
        }

        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields":"email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod:  .get)
        facebookRequest.start(completion: {_,result,error in
            guard let result = result as? [String:Any], error  == nil else {
                print("Failed to facebook request")
                return
            }
            print("\(result)")
            guard let userName = result["name"] as? String, let email = result["email"] as? String else{
                print("Failed to get email and name from fb result")
                return
            }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else
            {
                return
            }
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            DatabaseManager.shared.userExists(with: email, completion: {exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailAddress: email))
                }
            })
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) {[weak self] authResult, error in
                guard let strongSelf = self else {return}
                guard let _ = authResult, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed \(error)")
                    }
                   
                    return
                }
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    
}
