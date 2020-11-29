//
//  DetailFoodViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit
import SDWebImage

class DetailFoodViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        imageFood.alpha = 0.9
        setData()
        
    }
    
    func setData(){
        imageFood.sd_setImage(with: URL(string: img), completed: nil)
        lblNameFood.text = name
        lblPrice.text = price
        lblContent.text = content
    }
    
    @IBAction func btnDeleteFood(_ sender: Any) {
        let alert = UIAlertController(title: "Delete transaction", message: "Are you sure to delete this transaction?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            Defined.ref.child("Menu/Food/\(self.idFood)").removeValue { (error, reference) in
                if error != nil {
                    print("Error: \(error!)")
                } else {
                    print(reference)
                    print("Remove successfully")
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }))
        self.present(alert, animated: true)
        
    }
    
    @IBAction func btnEditFood(_ sender: Any) {
    }
    
}
