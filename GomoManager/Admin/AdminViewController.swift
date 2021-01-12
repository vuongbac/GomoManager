

import UIKit
import Firebase
import SDWebImage
import GoogleSignIn

class AdminViewController: UIViewController {
    
    @IBOutlet weak var avatarAdmin: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameAdmin: UILabel!
    var acount = [Account]()
    
    var listTitleCell = [Constans.cell1,
                         Constans.cell2,
                         Constans.cell3,
                         Constans.cell4 ]
    var listImageCell = ["manager", "notification", "setup_table", "logout"]
    
    let email = Defined.defaults.value(forKey: "email") as? String
    let avatar = Defined.defaults.value(forKey: "avatar") as? String
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameAdmin.text = email
        AdminCell.registerCellByNib(tableView)
        setUp()
    }
    
    func setUp()  {
        nameAdmin.text = email
        avatarAdmin.addShadow(radius: 10)
        avatarAdmin.addBoder(radius: 50, color: #colorLiteral(red: 0.1170637682, green: 0.6766145825, blue: 0.9572572112, alpha: 1))
        avatarAdmin.sd_setImage(with: URL(string: "https://lh3.googleusercontent.com\(String(avatar ?? ""))"), completed: nil)
    }
    
}
extension AdminViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listTitleCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AdminCell.loadCell(tableView) as! AdminCell
        cell.setUpCell(nameCell: listTitleCell[indexPath.row], imageCell: listImageCell[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.addemploys) as! EmployeesViewController
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            AlertUtil.showAlert(from: self, with: Constans.title, message: Constans.mess1)
        case 2:
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.setUpTable) as! setUpTableViewController
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            DispatchQueue.main.async {
                Defined.defaults.removeObject(forKey: "email")
                Defined.defaults.removeObject(forKey: "avatar")
                GIDSignIn.sharedInstance()?.signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.login) as! LoginViewController
                vc.modalPresentationStyle  = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
}


