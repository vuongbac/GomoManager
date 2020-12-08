//
//  DetailFoodViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit
import SDWebImage

class DetailFoodViewController: UIViewController {
    
    @IBOutlet weak var btnStatus: UISwitch!
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var lblNameFood: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblContent: UITextView!
    @IBOutlet weak var btnDelete: UIBarButtonItem!
    
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
        imageFood.sd_setImage(with: URL(string: img), completed: nil)
        lblNameFood.text = name
        let PriceFood = Int(price)
        lblPrice.text = "\(Defined.formatter.string(from: NSNumber(value: PriceFood ?? 0 ))!)" + " VNĐ"
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
        let alert = UIAlertController(title: "Delete Food",
                                      message: "Are you sure to delete this Food?",
                                      preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        alert.addAction(UIAlertAction(title: "Yes",
                                      style: .default,
                                      handler: { action in
                                        if self.statusMenu == "drink"{
                                            Defined.ref.child("Menu/Drink/\(self.idFood)").removeValue { (error, reference) in
                                                if error != nil {
                                                    print(error!)
                                                } else {
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            }
                                        }else{
                                            Defined.ref.child("Menu/Food/\(self.idFood)").removeValue { (error, reference) in
                                                if error != nil {
                                                    print(error!)
                                                } else {
                                                    self.navigationController?.popViewController(animated: true)
                                                }
                                            }
                                        }
                                      }))
        self.present(alert, animated: true)
    }
    
    @IBAction func btnEditFood(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EditFoodViewController") as! EditFoodViewController
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
            if statusMenu == "drink"{
                Defined.ref.child("Menu/Drink").child(idFood).updateChildValues(["statusFood":"0"])
            }else{
                Defined.ref.child("Menu/Food").child(idFood).updateChildValues(["statusFood":"0"])
            }
            
        }else{
            print("off")
            if statusMenu == "drink"{
                Defined.ref.child("Menu/Drink").child(idFood).updateChildValues(["statusFood":"1"])
            }else{
                Defined.ref.child("Menu/Food").child(idFood).updateChildValues(["statusFood":"1"])
            }
            
        }
        
    }
    
}
