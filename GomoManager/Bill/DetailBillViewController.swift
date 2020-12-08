//
//  DetailBillViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit
import Firebase

class DetailBillViewController: UIViewController {
    

    @IBOutlet weak var numberTable: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblListFood: UILabel!
    @IBOutlet weak var lblEmploysPay: UILabel!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var btnPay1: UIButton!
    
    var detailFood = ""
    var amount = 0
    var date = ""
    var numberTb = ""
    var status = ""
    var time = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customView()
        setDataBill()
        getDataBill()
        setUp()
    }
    
    func customView(){
        subView.layer.borderWidth = 1
        subView.layer.borderColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        subView.layer.cornerRadius = 5
        subView.layer.shadowRadius = 5
        subView.layer.shadowColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
    }
    
    func setUp(){
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
    }
    
    func setDataBill() {
        if status == "1"{
            btnPay1.isEnabled = false
        }else{
           btnPay1.isEnabled = true
        }
        lblListFood.text = detailFood
        lblPrice.text = "\(Defined.formatter.string(from: NSNumber(value: amount ))!)" + " VNĐ"
        lblDate.text = date
        numberTable.text = "Bàn số: \(numberTb)"
    }
    
    
    func getDataBill(){
        Defined.ref.child("Bill/Present").observe(DataEventType.value) { [self] (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let detilbill = value["detilbill"] as! String
                        let total = value["total"] as! Int
                        let date = value["date"] as! String
                        let time = value["time"] as! String
                        
                        if id == self.numberTb{
                            self.lblListFood.text = detilbill
                            self.lblDate.text = time
                            self.lblPrice.text = "\(Defined.formatter.string(from: NSNumber(value: total ))!)" + " VNĐ"
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnScanBill(_ sender: Any) {
        let printController = UIPrintInteractionController.shared
        let printInfo = UIPrintInfo(dictionary:nil)
        printInfo.outputType = UIPrintInfo.OutputType.general
        printInfo.jobName = "print"
        printController.printInfo = printInfo
        printController.printingItem = subView.toImage()
        printController.present(animated: true, completionHandler: nil)
    }
    
    @IBAction func btnPay(_ sender: Any) {
        
    }
    
    func billDone(){
        let billDone = [
            "detilbill": detailFood ,
            "total": amount,
            "date":date,
            "time": time,
            "numbertable":numberTb,] as [String: Any]
        Defined.ref.child("Bill/Done").childByAutoId().setValue(billDone)
    }
    
    func billPay()  {
        Defined.ref.child("Bill/Present/\(Int(self.numberTb) ?? 0)").removeValue { (error, reference) in
            if error != nil {
                print("Error: \(error!)")
            } else {
                print(reference)
                print("Remove successfully")
                Defined.ref.child("Table/\(Int(self.numberTb) ?? 0)").updateChildValues(["statu": 1])
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}

extension UIView {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
