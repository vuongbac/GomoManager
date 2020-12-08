//
//  AddEmployeesViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit
import Firebase
import FirebaseAuth

class AddEmployeesViewController: UIViewController {

    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        btnAdd.layer.cornerRadius = 7
    }
    
    @IBAction func btnAddEmploys(_ sender: Any) {
        
//        let writeData: [String: Any] = [
//                    "email": txtEmail.text,
//                    "password": txtPassword.text,
//                    "name": "",
//                    "age": "",
//                    "phone": "",
//                    "cmnd": "",
//                    "address": ""]
        
        if let email = txtEmail.text, let password = txtPassword.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if authResult != nil{
                    //Defined.ref.child("Employees").childByAutoId().setValue(writeData)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    print("backol")
                    if let user = Auth.auth().currentUser {
                    }
                }
            }
        }
    }
}
