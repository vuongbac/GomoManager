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
    
    private var dataPicker: UIDatePicker?
    
    var bills = [Bill]()
    var moth2:Array<String> = ["1","2","3","4","5","6","7","8","9","10","11"]
    var totalMonth = [Int](repeating: 0, count: 12)
    var totalYear = 0
    var totalDay = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        dataPicker = UIDatePicker()
        dataPicker?.datePickerMode = .date
        getDataBill()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = components.day, let month = components.month, let year = components.year {
            print("\(day) \(month) \(year)")
        }
    }
    
    
    
    
    func getDataBill(){
        Defined.ref.child("Bill/Done").observe(DataEventType.value) { [self] (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.bills.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let date = value["date"] as! String
                        let detilbill = value["detilbill"] as! String
                        let numbertable = value["numbertable"] as! String
                        let total = value["total"] as! Int
                        
                        let bill = Bill(id: id, numberTable: numbertable, detailFood: detilbill, total: total, date: date)
                        self.bills.append(bill)
                        
                        let tempDate = date.split(separator: "/")
                        // lấy tổng doanh thu tháng
                        let checkDate = tempDate[1]
                        
                        // lấy tổng doanh thu của cả năm
                        let checkYear = tempDate[2]
                        
                        
                        self.totalMonth[(Int(String(checkDate)) ?? 0) - 1] += total/1000000
                        self.totalYear += total
                        self.amountYear.text = String(totalYear)
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
        
        let lineDataSet = LineChartDataSet(entries: lineData ,label: "Doanh thu cửa hàng theo tháng đơn vị / triệu ")
        let data = LineChartData(dataSet: lineDataSet)
        chartView.data = data
        
    }
    
}
