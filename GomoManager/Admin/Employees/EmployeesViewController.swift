

import UIKit
import Firebase

class EmployeesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var employees = [Employees]()
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataEmployees()
        EmployeesCell.registerCellByNib(tableView)
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
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func btnAddEmployees(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.addemploys) as! AddEmployeesViewController
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension EmployeesViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EmployeesCell.loadCell(tableView) as! EmployeesCell
        cell.setUp(data: employees[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: {_ in
            return self.addMenuItems(for: indexPath.row)
        })
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
 
    
    func addMenuItems(for index:Int) -> UIMenu {
        let e = employees[index]
        let menuItems = UIMenu(title: "", options: .displayInline, children: [
            UIAction(title: "Xóa", image: UIImage(named: "ic_delete"), handler: { (_) in
                let strEmail = e.email
                print("say hi\(e.email)")
                let tempString = strEmail!.split(separator: "@")
                print("say hu\(tempString)")
                let em = tempString[0]
                let user = Auth.auth().currentUser
                user?.delete { error in
                    if let error = error {
                        print(error)
                    } else {
                        Defined.ref.child("Account").child(self.idAdmin ?? "").child("Employees").child("\(em)").removeValue { (error, reference) in}
                        self.navigationController?.popViewController(animated: true)
                        
                    }
                }
               
            }),
            
            UIAction(title: "Sửa", image: UIImage(named: "ic_task_list"), handler: { (_) in
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.detailEmployes) as! DetailEmployessViewController
                vc.nameF = e.name ?? ""
                vc.emailE = e.email ?? ""
                vc.addF = e.address ?? ""
                vc.phoneF = e.phone ?? ""
                vc.imageE = e.avatar ?? ""
                vc.ageF = e.birtday ?? ""
                vc.sexF = e.gender ?? ""
                self.present(vc, animated: true, completion: nil)
            }),
        ])
        return menuItems
    }
}
