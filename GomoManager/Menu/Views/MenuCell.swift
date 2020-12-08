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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconFood.layer.cornerRadius = 7
        iconFood.layer.shadowRadius = 5
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUp(data:Food){
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        lblPrice.text = "\(Defined.formatter.string(from: NSNumber(value: data.price ?? 0 ))!)" + " VNĐ"
        lblNameFood.text = data.name
        lblContent.text = data.note
        iconFood.sd_setImage(with: URL(string: data.image ?? ""), completed: nil)
    }
}
