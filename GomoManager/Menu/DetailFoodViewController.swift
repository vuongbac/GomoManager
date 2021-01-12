

import UIKit
import SDWebImage

class DetailFoodViewController: UIViewController {
    
    @IBOutlet weak var btnStatus: UISwitch!
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var lblNameFood: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    @IBOutlet weak var textView: UITextView!
    
    
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    var img: String = ""
    var name: String = ""
    var price: String = ""
    var content: String = ""
    var idFood: String = ""
    var statusMenu = ""
    var statusFood = "" 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }
    
    func setData(){
        Defined.formatter.groupingSeparator = "."
        Defined.formatter.numberStyle = .decimal
        textView.addBoder(radius: 8, color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
        imageFood.sd_setImage(with: URL(string: img), completed: nil)
        lblNameFood.text = name
        let PriceFood = Int(price)
        lblPrice.text = "\(Defined.formatter.string(from: NSNumber(value: PriceFood ?? 0 ))!)" + " đ"
        lblContent.text = content
        self.navigationController?.navigationBar.tintColor = .black
        imageFood.alpha = 0.9
        if statusFood == "1"{
            btnStatus.isOn = false
        }else{
            btnStatus.isOn = true
        }
    }
    
    @IBAction func btnDeleteFood(_ sender: Any) {
        AlertUtil.actionAlert(from: self, with: Constans.title, message: Constans.deleteFood) { (ac) in
            switch self.statusMenu {
            case "drink":
                Defined.ref.child("Account").child(self.idAdmin ?? "").child("Menu/Drink/\(self.idFood)").removeValue { (error, reference) in}
                self.navigationController?.popViewController(animated: true)
            case "food":
                Defined.ref.child("Account").child(self.idAdmin ?? "").child("Menu/Food/\(self.idFood)").removeValue { (error, reference) in}
                self.navigationController?.popViewController(animated: true)
            default:
                Defined.ref.child("Account").child(self.idAdmin ?? "").child("Menu/Other/\(self.idFood)").removeValue { (error, reference) in}
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func btnEditFood(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constans.editFood) as! EditFoodViewController
        vc.img = img
        vc.idFood = idFood
        vc.name = name
        vc.content = content
        vc.idFood = idFood
        vc.price = price
        vc.statusMenu = statusMenu
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func btnStatusFood(_ sender: UISwitch) {
        if sender.isOn{
            print("on")
            switch statusMenu {
            case "drink":
                Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Drink").child(idFood).updateChildValues(["statusFood":"0"])
            case "food":
                Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Food").child(idFood).updateChildValues(["statusFood":"0"])
            default:
                Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Other").child(idFood).updateChildValues(["statusFood":"0"])
            }
        }else{
            print("off")
            switch statusMenu {
            case "drink":
                Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Drink").child(idFood).updateChildValues(["statusFood":"1"])
            case "food":
                Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Food").child(idFood).updateChildValues(["statusFood":"1"])
            default:
                Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Other").child(idFood).updateChildValues(["statusFood":"1"])
            }
            
        }
        
    }
    
}
