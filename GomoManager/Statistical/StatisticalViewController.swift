//
//  StatisticalViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 11/13/20.
//

import UIKit
import Charts
import Firebase

class StatisticalViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var amountDay: UILabel!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var amountYear: UILabel!
    @IBOutlet weak var lblSelectYear: UILabel!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    private var dataPicker: UIDatePicker?
    
    var bills = [Bill]()
    var moth2:Array<String> = ["1","2","3","4","5","6","7","8","9","10","11"]
    var totalMonth = [Int](repeating: 0, count: 12)
    var totalYear = 0
    var totalDay = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpdata()
        getDataBill()
    }
    
    func setUpdata() {
        dataPicker = UIDatePicker()
        dataPicker?.datePickerMode = .date
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.labelTapped(_:)))
                self.lblSelectYear.isUserInteractionEnabled = true
                self.lblSelectYear.addGestureRecognizer(labelTap)
       
    }
    @objc func labelTapped(_ sender: UITapGestureRecognizer) {
            print("labelTapped")
        }
    
    func getDataBill(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Bill/Done").observe(DataEventType.value) { [self] (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.bills.removeAll()
                self.totalYear = 0
                self.totalDay = 0
                self.totalMonth = [Int](repeating: 0, count: 12)
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let date = value["date"] as! String
                        let detilbill = value["detilbill"] as? String
                        let numbertable = value["numbertable"] as? String
                        let total = value["total"] as! Int
                        print(total)
                        
                        let bill = Bill(id: id, numberTable: numbertable, detailFood: detilbill, total: total, date: date)
                        self.bills.append(bill)
                        let tempDate = date.split(separator: "/")
                        // lấy tổng doanh thu ngày hiên tại
                        
                        // lấy tổng doanh thu tháng
                        let checkDate = tempDate[1]
                        
                        // lấy tổng doanh thu của cả năm
                        let checkYear = tempDate[2]
                        if checkYear == "2020" {
                            self.totalYear += total 
                            self.amountYear.text = "\(Defined.formatter.string(from: NSNumber(value: totalYear ))!)" + " VNĐ"
                        }
                        let dateThis = dateFormatTime(date: Date())
                        let temp = dateThis.split(separator: "/")
                        let checkDayData = tempDate[0]
                        let checkDaySystem = temp[0]
                        if checkDayData == checkDaySystem{
                            self.totalDay += total
                            self.amountDay.text = "\(Defined.formatter.string(from: NSNumber(value: totalDay ))!)" + " VNĐ"
                        }
                        self.totalMonth[(Int(String(checkDate)) ?? 0) - 1] += total/1000000
                        self.setChartValue(name: self.moth2, data: self.totalMonth)
                    }
                }
            }
        }
    }
    
    func setChartValue(name:[String], data:[Int]) {
        var lineData:[ChartDataEntry] = []
        for i in 0...name.count {
            let data: ChartDataEntry = ChartDataEntry(x: Double(i), y: Double(data[i]))
            lineData.append(data)
        }
        let lineDataSet = LineChartDataSet(entries: lineData ,label: "Doanh thu cửa hàng theo tháng đơn vị /triệu ")
        let data = LineChartData(dataSet: lineDataSet)
        chartView.data = data
    }
    
    func dateFormatTime(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
