//
//  AddEmployeesViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit

class AddEmployeesViewController: UIViewController {

    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var selectMale: UIButton!
    @IBOutlet weak var selectFemale: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    var sex = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        sex = "nam"

    }
    func setUpView(){
        customView.layer.borderWidth = 2
        customView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customView.layer.cornerRadius = 20
        
        btnAdd.layer.borderWidth = 1
        btnAdd.layer.cornerRadius = 10

        btnCancel.layer.borderWidth = 1
        btnCancel.layer.cornerRadius = 10
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAdd(_ sender: Any) {
        let writeData: [String: Any] = [
            "name": txtName.text,
            "sex": sex,
            "phone": txtPhone.text,
            "userName": txtUserName.text,
            "password": txtPassword.text]
            Defined.ref.child("Employees").childByAutoId().setValue(writeData)
    }
    
    @IBAction func btnSelectMale(_ sender: Any) {
        selectFemale.setImage(UIImage(named: "unselect"), for: UIControl.State.normal)
        selectMale.setImage(UIImage(named: "select"), for: UIControl.State.normal)
        sex = "nam"
    }
    @IBAction func btnSelectFemale(_ sender: Any) {
        selectFemale.setImage(UIImage(named: "select"), for: UIControl.State.normal)
        selectMale.setImage(UIImage(named: "unselect"), for: UIControl.State.normal)
        sex = "nữ"
    }
    
}
