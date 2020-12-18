//
//  setUpTableViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/16/20.
//

import UIKit
import Firebase

class setUpTableViewController: UIViewController {
    @IBOutlet weak var lblCountTable: UITextField!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    var numberTable = 0
    var tables = [Table]()
    var updateTable = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNumberTable()
    }
    
    func getNumberTable(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Table").observe(DataEventType.value) { (DataSnapshot) in
            self.tables.removeAll()
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshort {
                    _ = snap.key
                    if let value = snap.value as? [String: Any] {
                        let statu = value["statu"] as! Int
                        let numberTable = value["NumberTable"] as! Int
                        let table = Table(statu: statu, NumberTable: numberTable)
                        self.tables.append(table)
                        if statu == 3 || statu == 2 {
                            self.updateTable = 3
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnSetUpTable(_ sender: Any) {
        if updateTable == 3  {
            AlertUtil.showAlert(from: self, with: Constans.title, message: Constans.message1)
        }else{
            AlertUtil.actionAlert(from: self, with: Constans.title, message: Constans.message2) { (ac) in
                Defined.ref.child("Account").child(self.idAdmin ?? "").child("Table").removeValue()
                if let strTable = self.lblCountTable.text,
                   let intTable = Int(strTable){
                    self.numberTable = intTable
                    for numberCount in 1...self.numberTable {
                        let writeData: [String: Any] = [
                            "statu": 1,
                            "NumberTable": numberCount]
                        Defined.ref.child("Account").child(self.idAdmin ?? "").child("Table").child("\(numberCount)").updateChildValues(writeData) { (error, reference) in
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
}
