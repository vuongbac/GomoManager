//
//  AdminCell.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit

class AdminCell: BaseTBCell {

    @IBOutlet weak var lbldDetailCell: UILabel!
    @IBOutlet weak var imagecell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpCell(nameCell: String, imageCell: String) {
        lbldDetailCell.text = nameCell
        imagecell.image = UIImage(named: imageCell)
    }
    
}
