//
//  BillCell.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit

class BillCell: BaseTBCell {

    @IBOutlet weak var lblTable: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpData(data: Bill){
        lblDate.text =  "Ngày: " + data.date!
        lblTable.text = "Bàn số: " + data.numberTable!
        lblPrice.text = String( data.Total ?? 0) + " VNĐ"
    }
    
}
