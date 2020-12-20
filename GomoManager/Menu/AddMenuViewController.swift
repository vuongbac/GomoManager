
import UIKit
import Firebase

class AddMenuViewController: UIViewController {
    
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var txtNameFood: UITextField!
    @IBOutlet weak var txtPriceFood: UITextField!
    @IBOutlet weak var txtContent: UITextView!
    @IBOutlet weak var tbnAdd: UIButton!
    
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    var imagePicker = UIImagePickerController()
    var foods = [Food]()
    var price = 0
    var statusMenu = ""
    var idFood: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        tbnAdd.layer.borderWidth = 0.5
        tbnAdd.layer.cornerRadius = 25
        imageFood.alpha = 0.9
        self.getFoodsData()
    }
    
    @IBAction func tbnSelectImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func addDataMenu(){
        var isChecked = true
        for item in 0 ..< idFood.count {
            if txtNameFood.text?.lowercased() == idFood[item].lowercased() {
                AlertUtil.showAlert(from: self, with: "Gomo", message: "Món ăn đã có trong menu")
                isChecked = false
            }
        }
        
        if isChecked {
            if let strPrice = txtPriceFood.text,
               let intPrice = Int(strPrice){
                price = intPrice
            }
            guard let imageData  = imageFood.image?.pngData() else{
                return
            }
            Defined.storage.child("images/\(txtNameFood.text ?? "").png").putData(imageData, metadata: nil, completion: { [self] _, error in
                guard error == nil else {
                    return
                }
                Defined.storage.child("images/\(txtNameFood.text ?? "").png").downloadURL(completion: { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    let writeData: [String: Any] = [
                        "namefood": self.txtNameFood.text!,
                        "notefood": self.txtContent.text!,
                        "price" : self.price,
                        "statusFood":"1",
                        "imagefood":"\(url)"]
                    switch statusMenu {
                    case "drink":
                        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Drink").child(self.txtNameFood.text!).setValue(writeData)
                    case "food":
                        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Food").child(self.txtNameFood.text!).setValue(writeData)
                    default:
                        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Other").child(self.txtNameFood.text!).setValue(writeData)
                    }
                })
            })
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func btnAddFood(_ sender: Any) {
        addDataMenu()
    }
    
    func getFoodsData(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Food").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.foods.removeAll()
                self.idFood.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    self.idFood.append(id)
                }
            }
        }
    }
}

extension AddMenuViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageFood.contentMode = .scaleAspectFit
            imageFood.image = pickedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
