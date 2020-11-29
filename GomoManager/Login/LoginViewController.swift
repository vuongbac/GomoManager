//
//  LoginViewController.swift
//  GomoAdmin
//
//  Created by Vương Toàn Bắc on 11/24/20.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController, UITabBarControllerDelegate {

    @IBOutlet weak var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        GIDSignIn.sharedInstance()?.delegate = self
    }
    
    func setUpButton(){
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        btnLogin.layer.cornerRadius = 7
    }
    
    @IBAction func btnLoginGoogle(_ sender: Any) {
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance()?.signIn()
        
    }
}

extension LoginViewController: GIDSignInDelegate{
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error == nil{
            
            let pathURL =  user.profile.imageURL(withDimension: 200)
            let pathString = pathURL?.path
            
            let avatar = pathString
            let email = user?.profile.email
            
            Defined.defaults.set(email, forKey: "email" )
            Defined.defaults.set(avatar, forKey: "avatar")
            
            
            let email1 = Defined.defaults.value(forKey: "email") as! String

            let profile = [
                "avatar" : pathString,
                "email" : user.profile.email as Any,
                "balance" : 0
                ] as [String : Any]
            
            Defined.ref.child("Account").child("\(String(describing: user.userID))").setValue(profile,withCompletionBlock: { error , ref in
                if error == nil {
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
                    vc.modalPresentationStyle = .fullScreen
                    print(email1)
                    self.present(vc, animated: true, completion: nil)
                }
                else {}
            })
            
        }else{
            print(error as Any)
        }
    }
}
