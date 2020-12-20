
import UIKit
import Firebase

class TableCCell: BaseCLCell {
    
    @IBOutlet weak var nameCreactor: UILabel!
    @IBOutlet weak var statusTable: UIView!
    @IBOutlet weak var lblNumbleTable: UILabel!
    @IBOutlet weak var subView: UIView!
    
    var idCart = 0
    var idTable = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    func setUp(){
        statusTable.layer.cornerRadius = 20
        statusTable.layer.borderWidth = 2
        subView.layer.cornerRadius = 20
        subView.layer.borderWidth = 2
    }
    
    func setUp(data: Table){
        lblNumbleTable.text = String( data.NumberTable!)
        nameCreactor.text =  String(data.nameCreactor ?? "")
    }
    
    func setupID(idCart: Int, idTable: Int) {
        self.idCart = idCart
        self.idTable = idCart
    }
}
