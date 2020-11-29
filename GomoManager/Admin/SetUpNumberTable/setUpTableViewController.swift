//
//  setUpTableViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit

class setUpTableViewController: UIViewController {
    @IBOutlet weak var lblCountTable: UITextField!
    var numberTable = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func btnSetUpTable(_ sender: Any) {
        
        if let strTable = lblCountTable.text,
            let intTable = Int(strTable){
            numberTable = intTable
        }
        
        for numberCount in 1...numberTable {
            
            let writeData: [String: Any] = [
                "statu": 1,
                "NumberTable": numberCount]
                Defined.ref.child("Table").child("\(numberCount)").setValue(writeData)
        }
        
    }
}
