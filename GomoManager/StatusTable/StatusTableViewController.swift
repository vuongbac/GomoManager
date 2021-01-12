

import UIKit
import Firebase

class StatusTableViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    var tables = [Table]()
    var status = 1
    var updateTable = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableCCell.registerCellByNib(collectionView)
        getNumberTable()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint) {
                let tb = tables[indexPath.row]
                let nameTbale = tb.NumberTable ?? 0
                if tables[indexPath.row].statu == 1{
                    AlertUtil.actionAlert(from: self, with: Constans.title, message: Constans.deleteTable) { (ac) in
                        Defined.ref.child("Account").child(self.idAdmin ?? "").child("Table").child(String(nameTbale)).removeValue()
                    }
                }
            }
        }
    }
    
    
    func getNumberTable(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Table").observe(DataEventType.value) { (DataSnapshot) in
            self.tables.removeAll()
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshort {
                    _ = snap.key
                    if let value = snap.value as? [String: Any] {
                        let nameCreactor = value["nameCreactor"] as? String
                        let statu = value["statu"] as! Int
                        let numberTable = value["NumberTable"] as! Int
                        let table = Table(statu: statu, NumberTable: numberTable, nameCreactor: nameCreactor)
                        self.tables.append(table)
                    }
                }
                self.collectionView.reloadData()
            }
        }
    }
}

extension StatusTableViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tables.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TableCCell.loadCell(collectionView, path: indexPath) as! TableCCell
        cell.setUp(data: tables[indexPath.row])
        switch tables[indexPath.row].statu  {
        case 0:
            cell.subView.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case 1:
            cell.subView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default:
            cell.subView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }
        return cell
    }
    
}

