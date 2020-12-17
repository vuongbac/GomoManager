//
//  DetailEmployessViewController.swift
//  GomoManager
//
//  Created by Vương Toàn Bắc on 12/17/20.
//

import UIKit
import SDWebImage
import Firebase

class DetailEmployessViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSex: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var bntDelete: UIButton!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String

    var imageE = ""
    var emailE = ""
    var nameF = ""
    var sexF = ""
    var ageF = ""
    var addF = ""
    var phoneF = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpData()
    }
    
    func setUpData()  {
        lblSex.text = sexF
        lblAge.text = ageF
        lblAdd.text = addF
        lblName.text = nameF
        lblEmail.text = emailE
        lblPhone.text = phoneF
        avatar.sd_setImage(with: URL(string: imageE), completed: nil)
        avatar.layer.cornerRadius = avatar.bounds.size.width/2
    }
    
    @IBAction func btnEdit(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeesViewController") as! AddEmployeesViewController
        vc.edit = "edit"
        vc.nameF = nameF
        vc.emailE = emailE
        vc.sexF = sexF
        vc.phoneF = phoneF
        vc.ageF = addF
        vc.ageF = ageF
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func btbDelete(_ sender: Any) {
        let cutEmail = emailE
        let tempString = cutEmail.split(separator: "@")
        let em = tempString[0]
        let user = Auth.auth().currentUser
        user?.delete { error in
          if let error = error {
            print(error)
          } else {
            Defined.ref.child("Account").child(self.idAdmin ?? "").child("Employees").child("\(em)").removeValue { (error, reference) in}
            self.navigationController?.popViewController(animated: true)          }
        }
       
    }
    
}
