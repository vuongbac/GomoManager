//
//  BillViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit
import Firebase

class BillViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String

    
    var bills = [Bill]()
    override func viewDidLoad() {
        super.viewDidLoad()
        BillCell.registerCellByNib(tableView)
        getBillPresent()
    }
    
   
    @IBAction func btnSelectBill(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            getBillPresent()
        }else{
            getBillDone()
        }
    }
    
    
    func getBillDone(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Bill/Done").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.bills.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let date = value["date"] as! String
                        let detilbill = value["detilbill"] as! String
                        let numbertable = value["numbertable"] as! String
                        let total = value["total"] as! Int
                        let bill = Bill(id: id,numberTable: numbertable, detailFood: detilbill, total: total, date: date)
                        self.bills.append(bill)
                    }
                }
            }
            self.tableView.reloadData()

        }
    }
    
    
    func getBillPresent(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Bill/Present").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.bills.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let date = value["date"] as! String
                        let detilbill = value["detilbill"] as! String
                        let numbertable = value["numbertable"] as! String
                        let total = value["total"] as! Int
                        let bill = Bill(id: id,numberTable: numbertable, detailFood: detilbill, total: total, date: date)
                        self.bills.append(bill)
                    }
                }
            }
            self.tableView.reloadData()

        }
    }
    
}
extension BillViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BillCell.loadCell(tableView) as! BillCell
        cell.setUpData(data:bills[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBillViewController") as! DetailBillViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true, completion: nil)
    }
}
 
