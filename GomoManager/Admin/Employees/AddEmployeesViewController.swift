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
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtAdd: UITextField!
    @IBOutlet weak var selectGender: UISegmentedControl!
    var ImagePicker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        ImagePicker.delegate = self
        btnAdd.layer.cornerRadius = 7
        avatar.layer.cornerRadius = 50
        avatar.layer.borderWidth = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        ImagePicker.allowsEditing = false
        ImagePicker.sourceType = .photoLibrary
        self.present(ImagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            avatar.contentMode = .scaleAspectFit
            avatar.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnAddEmploys(_ sender: Any) {
        addDataEmployees()
    }
    
    
    func addDataEmployees(){
        let cutEmail = txtEmail.text
        let tempString = cutEmail?.split(separator: "@")
        let em = tempString?[0]
        
        guard let imageData  = avatar.image?.pngData() else{
            return
        }
        Defined.storage.child("images/\(txtName.text ?? "").png").putData(imageData, metadata: nil, completion: { [self] _, error in
            guard error == nil else {
                print("failed to upload")
                return
            }
            Defined.storage.child("images/\(txtName.text ?? "").png").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let writeData: [String: Any] = [
                    "email": txtEmail.text ?? "",
                    "password": txtPassword.text ?? "",
                    "name": txtName.text ?? "",
                    "birthday": txtBirthday.text ?? "",
                    "avatar": "\(url)",
                    "address": txtAdd.text ?? ""]
                
                if let email = txtEmail.text, let password = txtPassword.text{
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if authResult != nil{
                            Defined.ref.child("Employees").child("\(em ?? "")").setValue(writeData)
                            self.navigationController?.popViewController(animated: true)
                        }else{
                            if let user = Auth.auth().currentUser {
                                user.getIDToken { (token, er) in
                                    print("email da ton tai")
                                }
                            }
                        }
                    }
                }
                
            })
        })
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddEmployeesViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
}
