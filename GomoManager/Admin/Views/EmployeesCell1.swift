

import UIKit

class EmployeesCell1: BaseCLCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var subView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }
    
    func setUpView(){
        imgAvatar.addBoder(radius: 8, color: #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1))
        subView.addBoder(radius: 8, color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    }
    
    func setUp(data: Employees) {
        lblName.text = data.name
        imgAvatar.sd_setImage(with: URL(string: data.avatar ?? ""), completed: nil)
    }

}
