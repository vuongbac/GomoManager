

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
        imgAvatar.layer.cornerRadius = imgAvatar.bounds.width/2
        subView.layer.cornerRadius = 20
    }
    
    func setUp(data: Employees) {
        lblName.text = data.name
        imgAvatar.sd_setImage(with: URL(string: data.avatar ?? ""), completed: nil)
    }

}
