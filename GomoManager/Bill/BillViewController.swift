

import UIKit
import Firebase

class BillViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmented: UISegmentedControl!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String

    var bills = [Bill]()
    var status = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        BillCell.registerCellByNib(tableView)
        getBillPresent()
        status = "0"
    }
    
    @IBAction func btnSelectBill(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            getBillPresent()
            status = "0"
        }else{
            getBillDone()
            status = "1"
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
                        let listpricefood = value["listpricefood"] as? String
                        let numbertable = value["numbertable"] as! String
                        let total = value["total"] as! Int
                        let time = value["time"] as? String
                        let discount = value["discount"] as? String
                        let note = value["note"] as? String
                        let othermoney = value["othermoney"] as? String
                        let totalPay = value["totalpay"] as? Int
                        let bill = Bill(id: id, othermoney: othermoney, numberTable: numbertable, detailFood:detilbill, Total: total, date: date, discouunt: discount, time: time, listpricefood: listpricefood, note: note, totalPay: totalPay)
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
                        let listpricefood = value["listpricefood"] as? String
                        let total = value["total"] as! Int
                        let time = value["time"] as! String
                        let bill = Bill(id: id,numberTable: numbertable, detailFood: detilbill, Total: total, date: date ,time: time,listpricefood: listpricefood)
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
        cell.setUpData(data: bills[indexPath.row], s:status)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailBillViewController") as! DetailBillViewController
        let detailBill = bills[indexPath.row]
        vc.amount = detailBill.Total ?? 0
        vc.detailFood = detailBill.detailFood ?? ""
        vc.date = detailBill.date ?? ""
        vc.time = detailBill.time ?? ""
        vc.numberTb = detailBill.numberTable ?? ""
        vc.status = status
        vc.note = detailBill.note ?? ""
        vc.discount1 = detailBill.discouunt ?? ""
        vc.othermoney = detailBill.othermoney ?? ""
        vc.listpricefood = detailBill.listpricefood ?? ""
        vc.totalPay1 = detailBill.totalPay ?? 0
        self.present(vc, animated: true, completion: nil)
    }
}
 
