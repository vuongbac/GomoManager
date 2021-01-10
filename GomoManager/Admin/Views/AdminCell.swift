
import UIKit

class AdminCell: BaseTBCell {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var lbldDetailCell: UILabel!
    @IBOutlet weak var imagecell: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        subView.addShadow(radius: 5)
        subView.addBoder(radius: 10, color: #colorLiteral(red: 0.1170637682, green: 0.6766145825, blue: 0.9572572112, alpha: 1))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpCell(nameCell: String, imageCell: String) {
        lbldDetailCell.text = nameCell
        imagecell.image = UIImage(named: imageCell)
    }
    
}
