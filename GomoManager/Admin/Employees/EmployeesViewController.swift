//
//  EmployeesViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit
import Firebase

class EmployeesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var employees = [Employees]()
    override func viewDidLoad() {
        super.viewDidLoad()
      //  getDataEmployees()
        EmployeesCell.registerCellByNib(tableView)
    }
    
    func getDataEmployees(){
        Defined.ref.child("Employees").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.employees.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let name = value["name"] as! String
                        let sex = value["sex"] as! String
                        let phone = value["phone"] as! String
                        let username = value["userName"] as! String
                        let password = value["password"] as! String
                        let em = Employees(id: id, name: name, phone: phone, sex: sex, username: username, password: password)
                        self.employees.append(em)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func btnAddEmployees(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEmployeesViewController") as! AddEmployeesViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EmployeesCell.loadCell(tableView) as! EmployeesCell
        cell.setUpData(data: employees[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var em = employees[indexPath.row]
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            Defined.ref.child("Employees/\(em.id ?? "")").removeValue { (error, reference) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    print(reference)
                }
            }
        }
        let share = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            // share item at indexPath
        }
        
        share.backgroundColor = UIColor.orange
        
        return [delete, share]
    }
    
}
