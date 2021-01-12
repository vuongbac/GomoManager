
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
        btnLogin.addShadow(radius: 5)
        btnLogin.addBoder(radius: 10, color: #colorLiteral(red: 0.1170637682, green: 0.6766145825, blue: 0.9572572112, alpha: 1))
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
            let idAdmin = user.userID
            
            Defined.defaults.set(email, forKey: "email" )
            Defined.defaults.set(avatar, forKey: "avatar")
            Defined.defaults.set(idAdmin, forKey: "idAdmin")
            
            let profile = [
                "avatar" : avatar as Any,
                "email" : email as Any,
                ] as [String : Any]
            Defined.ref.child("Account").child(idAdmin ?? "").child("Profile").setValue(profile)
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.tabbar) as! TabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
            
        }else{
            print(error as Any)
        }
    }
}
