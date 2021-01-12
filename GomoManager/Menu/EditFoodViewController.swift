
import UIKit

class EditFoodViewController: UIViewController {
    
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var txtDescribeFood: UITextView!
    @IBOutlet weak var txtNameFood: UITextField!
    @IBOutlet weak var txtPriceFood: UITextField!
    @IBOutlet weak var imageFood: UIImageView!
    @IBOutlet weak var textView: UITextView!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    
    var imagePicker = UIImagePickerController()
    var img: String = ""
    var name: String = ""
    var price: String = ""
    var content: String = ""
    var idFood: String = ""
    var prices = 0
    var statusMenu = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    func setUp(){
        imagePicker.delegate = self
        txtNameFood.text = name
        imageFood.sd_setImage(with: URL(string: img), completed: nil)
        txtPriceFood.text = price
        txtDescribeFood.text = content
        textView.addBoder(radius: 8, color: #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    }
    
    @IBAction func btnSave(_ sender: Any) {
        if let strPrice = txtPriceFood.text,
           let intPrice = Int(strPrice){
            prices = intPrice
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
                    "namefood": txtNameFood.text ?? "",
                    "notefood": txtDescribeFood.text ?? "",
                    "price" : self.prices,
                    "imagefood":"\(url)"]
                
                switch statusMenu{
                case "drink":
                    Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Drink").child("/\(idFood)").updateChildValues(writeData) { (error, reference) in }
                case "food":
                    Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Food").child("/\(idFood)").updateChildValues(writeData) { (error, reference) in }
                default:
                    Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Other").child("/\(idFood)").updateChildValues(writeData) { (error, reference) in }
                }
            })
        })
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
    }
    
    @IBAction func btnSelectImage(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension EditFoodViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
