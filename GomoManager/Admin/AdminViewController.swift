//
//  AdminViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit
import Firebase
import SDWebImage

class AdminViewController: UIViewController {
    
    @IBOutlet weak var avatarAdmin: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameAdmin: UILabel!
    var acount = [Account]()
    
    var listTitleCell = ["Quản lý nhân viên", "Thay đổi số bàn",  "Cài đặt thông báo", "Đăng xuất"]
    var listImageCell = ["manager", "notification", "setup_table", "logout"]
    
    let email = Defined.defaults.value(forKey: "email") as! String
    let avatar = Defined.defaults.value(forKey: "avatar") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAdmin.text = email
        AdminCell.registerCellByNib(tableView)
        setUp()
        print("bacnn\(String(avatar ?? ""))")
    }
    
    func setUp()  {
        nameAdmin.text = email
        avatarAdmin.sd_setImage(with: URL(string: "https://lh3.googleusercontent.com\(String(avatar ?? ""))"), completed: nil)
        print(avatar)
    }
    
}
extension AdminViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitleCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AdminCell.loadCell(tableView) as! AdminCell
        cell.setUpCell(nameCell: listTitleCell[indexPath.row], imageCell: listImageCell[indexPath.row])
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeesViewController") as! EmployeesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "setUpTableViewController") as! setUpTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EmployeesViewController") as! EmployeesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


