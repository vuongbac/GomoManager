//
//  StatusTableViewController.swift
//  GomoManager
//
//  Created by Vương Toàn Bắc on 12/10/20.
//

import UIKit
import Firebase

class StatusTableViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    var tables = [Table]()
    var status = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        TableCCell.registerCellByNib(collectionView)
        getNumberTable()
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
            cell.subView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        return cell
    }
    
}

