

import UIKit

class EmployeesCell: BaseTBCell {

    @IBOutlet weak var subView1: UIView!
    @IBOutlet weak var subView2: UIView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lbGerder: UILabel!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbBrithday: UILabel!
    @IBOutlet weak var lbAdd: UILabel!
    @IBOutlet weak var lbPhone: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        subView1.addBoder(radius: 20, color: #colorLiteral(red: 0.2274329066, green: 0.5870787501, blue: 0.9447389245, alpha: 1))
        subView2.addBoder(radius: 20, color: #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1))
        subView1.addShadow(radius: 20)
        avatar.addShadow(radius: 20)
        avatar.addBoder(radius: avatar.bounds.size.height/2, color: #colorLiteral(red: 0.2274329066, green: 0.5870787501, blue: 0.9447389245, alpha: 1))
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(data: Employees) {
        lbAdd.text = data.address
        lbEmail.text = data.email
        lbPhone.text = data.phone
        lbGerder.text = "Giới tính: \(data.gender ?? "")"
        lbBrithday.text = data.birtday
        userName.text = data.name
        avatar.sd_setImage(with: URL(string: data.avatar ?? ""), completed: nil)
    }
    
}
