//
//  EmployeesCell.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit

class EmployeesCell: BaseTBCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUpData(data: Employees)  {
        if data.sex == "nam" {
            icon.image = UIImage(named: "nam")
        }else{
            icon.image = UIImage(named: "nu")
        }
        userName.text = data.name
    }
    
}
