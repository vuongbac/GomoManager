//
//  AddEmployeesViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class AddEmployeesViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    @IBOutlet weak var txtAdd: UITextField!
    @IBOutlet weak var selectGender: UISegmentedControl!
    @IBOutlet weak var txtPhone: UITextField!
    private var dataPicker: UIDatePicker?

    var ImagePicker = UIImagePickerController()
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    var gender = ""
    var edit = ""
    var imageE = ""
    var emailE = ""
    var nameF = ""
    var sexF = ""
    var ageF = ""
    var addF = ""
    var phoneF = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        ImagePicker.delegate = self
        btnAdd.layer.cornerRadius = 7
        avatar.layer.cornerRadius = 50
        subView.layer.cornerRadius = 20
        avatar.layer.borderWidth = 1
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureRecognizer)
        dataPicker = UIDatePicker()
        dataPicker?.datePickerMode = .date
        dataPicker?.preferredDatePickerStyle = .wheels
        txtBirthday.inputView = dataPicker
        dataPicker?.addTarget(self, action: #selector(dataChange(dataPicker:)), for: .valueChanged)

        if edit == "edit"{
            txtEmail.text =  emailE
            txtAdd.text = addF
            txtName.text = nameF
            txtBirthday.text = ageF
            avatar.sd_setImage(with: URL(string: imageE), completed: nil)
            txtPhone.text = phoneF
            txtEmail.isEnabled = false
        }else{
            print("hi say")
        }
    }
    
    @objc func dataChange(dataPicker : UIDatePicker){
        txtBirthday.text = dateFormatTime(date: dataPicker.date)
        view.endEditing(true)

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
        
        if edit == "edit"{
            editDataEmployees()
        }else{
            if txtAdd.text?.count == 0 || txtName.text?.count == 0 || txtEmail.text?.count  == 6 || txtPhone.text?.count == 0 || txtBirthday.text?.count == 0 || txtPassword.text?.count == 0  {
                AlertUtil.showAlert(from: self, with: "Gomo", message: "Vui lòng nhập đủ các trường")
            }else{
                addDataEmployees()
            }
        }
        
    }
    
    @IBAction func btnSelectGender(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gender = "nam"
        }else{
            gender = "nữ"
        }
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
                    "gender": gender,
                    "phone": txtPhone.text ?? "",
                    "avatar": "\(url)",
                    "address": txtAdd.text ?? ""]
                if let email = txtEmail.text, let password = txtPassword.text{
                    if  isValidEmail(email: email) == false && email.count != 0{
                        AlertUtil.showAlert(from: self, with: Constans.title, message: Constans.alertEmail)
                    }else{
                        Auth.auth().currentUser?.updatePassword(to: password) { (error) in
                         
                        }
                    }
                    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if authResult != nil{
                            
                            Defined.ref.child("Account").child(idAdmin ?? "").child("Employees").child("\(em ?? "")").setValue(writeData)
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
    
    func editDataEmployees(){
        
        let cutEmail = txtEmail.text
        let tempString = cutEmail?.split(separator: "@")
        let em = tempString?[0]
        guard let imageData  = avatar.image?.pngData() else{
            return
        }
        Defined.storage.child("images/\(em).png").putData(imageData, metadata: nil, completion: { [self] _, error in
            guard error == nil else {
                return
            }
            Defined.storage.child("images/\(em).png").downloadURL(completion: { url, error in
                guard let url = url, error == nil else {
                    return
                }
                let editData: [String: Any] = [
                    "email": emailE,
                    "name": txtName.text ?? "",
                    "birthday": txtBirthday.text ?? "",
                    "gender": gender,
                    "phone": txtPhone.text ?? "",
                    "avatar": "\(url)",
                    "address": txtAdd.text ?? ""]
                
                Defined.ref.child("Account").child(idAdmin ?? "").child("Employees").child("\(em ?? "")").updateChildValues(editData)
            })
        })
        self.dismiss(animated: true, completion: nil)
    }
    



func isValidEmail(email: String) -> Bool {
    let emailRegEx = Constans.validateEmail
    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: email)
}
    
    func dateFormatTime(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}

extension AddEmployeesViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
}
