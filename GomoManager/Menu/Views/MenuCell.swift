//
//  MenuCell.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit
import SDWebImage

class MenuCell: BaseTBCell {
    
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var iconFood: UIImageView!
    @IBOutlet weak var lblNameFood: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var subView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        customView()
    }
    
    func customView(){
        iconFood.addShadow(radius: 5)
        iconFood.addBoder(radius: 7, color: #colorLiteral(red: 0.2274329066, green: 0.5870787501, blue: 0.9447389245, alpha: 0.8470588235))
        subView.addShadow(radius: 5)
        subView.addBoder(radius: 20, color: #colorLiteral(red: 0.2274329066, green: 0.5870787501, blue: 0.9447389245, alpha: 0.8470588235))
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setUp(data:Food){
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        lblPrice.text = "\(Defined.formatter.string(from: NSNumber(value: data.price ?? 0 ))!)" + " đ"
        lblNameFood.text = data.name
        lblContent.text = data.note
        iconFood.sd_setImage(with: URL(string: data.image ?? ""), completed: nil)
    }
}
