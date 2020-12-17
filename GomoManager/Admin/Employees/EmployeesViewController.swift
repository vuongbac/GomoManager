//
//  EmployeesViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit
import Firebase

class EmployeesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var employees = [Employees]()
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataEmployees()
        EmployeesCell1.registerCellByNib(collectionView)
    }
    
    func getDataEmployees(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Employees").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.employees.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let address = value["address"] as? String
                        let avatar = value["avatar"] as? String
                        let birtday = value["birthday"] as? String
                        let email = value["email"] as? String
                        let name = value["name"] as? String
                        let gender = value["gender"] as? String
                        let phone = value["phone"] as? String
                        let em = Employees(id: id, address: address, avatar: avatar, birtday: birtday, email: email, name: name,phone: phone, gender:gender)
                        self.employees.append(em)
                        print(em)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
    
    
    @IBAction func btnAddEmployees(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeesViewController") as! AddEmployeesViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}
extension EmployeesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return employees.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = EmployeesCell1.loadCell(collectionView, path: indexPath) as! EmployeesCell1
        cell.setUp(data: employees[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailEmployessViewController") as! DetailEmployessViewController
        let e = employees[indexPath.row]
        vc.nameF = e.name ?? ""
        vc.emailE = e.email ?? ""
        vc.addF = e.address ?? ""
        vc.phoneF = e.phone ?? ""
        vc.imageE = e.avatar ?? ""
        vc.ageF = e.birtday ?? ""
        vc.sexF = e.gender ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

