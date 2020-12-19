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
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var amountYear: UILabel!
    @IBOutlet weak var txtSelectYear: UITextField!
    var moth2:Array<String> = ["1","2","3","4","5","6","7","8","9","10","11"]
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    private var dataPicker: UIDatePicker?
    var bills = [Bill]()
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
        dataPicker?.preferredDatePickerStyle = .wheels
        txtSelectYear.inputView = dataPicker
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        dataPicker?.addTarget(self, action: #selector(dataChange(dataPicker:)), for: .valueChanged)
        
    }
    
    @objc func dataChange(dataPicker : UIDatePicker){
        txtSelectYear.text = dateFormatTime(date: dataPicker.date)
        getDataBill()
        view.endEditing(true)
    }
    
    func getDataBill(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Bill/Done").observe(DataEventType.value) { [self] snapshort in
            self.bills.removeAll()
            self.totalMonth = [Int](repeating: 0, count: 12)
            self.amountYear.text = String("0" + "VNĐ")
            totalYear = 0
            for case let snap as DataSnapshot in snapshort.children {
                guard let dict = snap.value as? [String:Any] else {
                    return
                }
                
                let date = dict["date"] as! String
                let total = dict["total"] as! Int
                
                let tempDate = date.split(separator: "/")
                let checkDay = tempDate[0] // day
                let checkMonth = tempDate[1] // month
                let checkYear = tempDate[2] // year
                
                if txtSelectYear.text! == checkYear{
                    self.totalYear += total
                    self.amountYear.text = "\(Defined.formatter.string(from: NSNumber(value: self.totalYear ))!)" + " VNĐ"
                    self.totalMonth[(Int(String(checkMonth)) ?? 0) - 1] += total/1000000
                }
                
                let dateThis = dateFormatTime2(date: Date())
                let temp = dateThis.split(separator: "/")
                let checkDaySystem = temp[0]
                if checkDay == checkDaySystem{
                self.totalDay += total
                self.amountDay.text = "\(Defined.formatter.string(from: NSNumber(value: totalDay ))!)" + " VNĐ"
            }
            }
            self.setChartValue(name: self.moth2, data: self.totalMonth)

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
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func dateFormatTime2(date : Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: date)
    }
}
