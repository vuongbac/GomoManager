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
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataEmployees()
        EmployeesCell1.registerCellByNib(collectionView)
    }
    
    func getDataEmployees(){
        Defined.ref.child("Employees").observe(DataEventType.value) { (DataSnapshot) in
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
                        let em = Employees(id: id, address: address, avatar: avatar, birtday: birtday, email: email, name: name)
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
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    
}

