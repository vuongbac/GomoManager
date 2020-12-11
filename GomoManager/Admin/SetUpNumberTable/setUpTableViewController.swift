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
    var numberTable = 0
    var tables = [Table]()
    var updateTable = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getNumberTable()
    }
    
    func getNumberTable(){
        Defined.ref.child("Table").observe(DataEventType.value) { (DataSnapshot) in
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
            let alert = UIAlertController(title: Constans.title, message: Constans.message1, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constans.ok, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let dialogMessage = UIAlertController(title:Constans.title, message: Constans.message2, preferredStyle: .alert)
            let ok = UIAlertAction(title: Constans.ok, style: .default, handler: { (action) -> Void in
                Defined.ref.child("Table").removeValue()
                if let strTable = self.lblCountTable.text,
                   let intTable = Int(strTable){
                    self.numberTable = intTable
                }
                for numberCount in 1...self.numberTable {
                    let writeData: [String: Any] = [
                        "statu": 1,
                        "NumberTable": numberCount]
                    Defined.ref.child("Table")
                    
                    Defined.ref.child("Table").child("\(numberCount)").updateChildValues(writeData) { (error, reference) in
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            })
            let cancel = UIAlertAction(title: Constans.cancel, style: .cancel) { (action) -> Void in
            }
            dialogMessage.addAction(ok)
            dialogMessage.addAction(cancel)
            self.present(dialogMessage, animated: true, completion: nil)
            
        }
    }
}
