
import UIKit
import Charts
import Firebase

class StatisticalViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var amountDay: UILabel!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var amountYear: UILabel!
    @IBOutlet weak var txtSelectYear: UITextField!
    @IBOutlet weak var subView1: UIView!
    @IBOutlet weak var subView2: UIView!
    
    
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
        buildChart()
        
    }
    
    func buildChart() {
         chartView.delegate = self
         chartView.chartDescription?.enabled = false
         chartView.pinchZoomEnabled = false
         chartView.dragEnabled = false
         chartView.setScaleEnabled(false)
         chartView.highlightPerTapEnabled = false
        chartView.legend.enabled = false

         let rightAxis = chartView.rightAxis
         rightAxis.axisMinimum = 0
         rightAxis.drawLabelsEnabled = false
         rightAxis.drawGridLinesEnabled = false
         rightAxis.drawAxisLineEnabled = false

         let leftAxis = chartView.leftAxis
         leftAxis.axisMinimum = 0
         leftAxis.gridLineDashLengths = [5, 5]
         leftAxis.drawAxisLineEnabled = false

         let xAxis = chartView.xAxis
         xAxis.labelPosition = .bottom
         xAxis.axisMinimum = 0
         xAxis.granularity = 1
         xAxis.granularityEnabled = true
         xAxis.drawGridLinesEnabled = false
         xAxis.drawAxisLineEnabled = false
        
        subView1.addShadow(radius: 5)
        subView1.addBoder(radius: 10, color: #colorLiteral(red: 0.1170637682, green: 0.6766145825, blue: 0.9572572112, alpha: 1))
        subView2.addShadow(radius: 5)
        subView2.addBoder(radius: 10, color: #colorLiteral(red: 0.1170637682, green: 0.6766145825, blue: 0.9572572112, alpha: 1))
        txtSelectYear.addBoder(radius: 15, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        txtSelectYear.text = "2021"
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
            totalDay  = 0
            for case let snap as DataSnapshot in snapshort.children {
                guard let dict = snap.value as? [String:Any] else {
                    return
                }
                
                let date = dict["date"] as! String
                let total = dict["totalpay"] as! Int
                
                let tempDate = date.split(separator: "/")
                let checkDay = tempDate[0] + "/" + tempDate[1] + "/" + tempDate[2] // day
                let checkMonth = tempDate[1] // month
                let checkYear = tempDate[2] // year
                
                if txtSelectYear.text! == checkYear{
                    self.totalYear += total
                    self.amountYear.text = "\(Defined.formatter.string(from: NSNumber(value: self.totalYear ))!)" + " VNĐ"
                    self.totalMonth[(Int(String(checkMonth)) ?? 0) - 1] += total/1000000
                }
                
                let dateThis = dateFormatTime2(date: Date())
                let temp = dateThis.split(separator: "/")
                let checkDaySystem = temp[0] + "/" + temp[1] + "/" + temp[2]
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
