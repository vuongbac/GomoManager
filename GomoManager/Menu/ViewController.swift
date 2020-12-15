//
//  ViewController.swift
//  GomoAdmin
//
//  Created by BAC Vuong Toan (VTI.Intern) on 10/19/20.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAddFood: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    
    let idAdmin = Defined.defaults.value(forKey: "idAdmin") as? String
    var foods = [Food]()
    var status = ""
    var strFood = [Food]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuCell.registerCellByNib(tableView)
        getFoodsData()
        status = "food"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    @IBAction func btnSelectMenu(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
        case 0:
            getFoodsData()
            status = "food"
        case 1:
            getDrinkData()
            status = "drink"
        default:
            getOtherData()
            status = "other"
        }
    }
    
    @IBAction func btnAddMenu(_ sender: Any) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMenuViewController") as! AddMenuViewController
        vc.statusMenu = status
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFoodsData(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Food").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.foods.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let namefood = value["namefood"] as! String
                        let imagefood = value["imagefood"] as! String
                        let notefood = value["notefood"] as! String
                        let pricefood = value["price"] as! Int
                        let statusFood = value["statusFood"] as? String
                        let food = Food(id: id, name: namefood, price: pricefood, image: imagefood, note: notefood ,statusFood: statusFood)
                        self.foods.append(food)
                    }
                }
            }
            self.strFood = self.foods
            self.tableView.reloadData()
        }
    }
    
    
    func getOtherData(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Other").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.foods.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let namefood = value["namefood"] as! String
                        let imagefood = value["imagefood"] as! String
                        let notefood = value["notefood"] as! String
                        let pricefood = value["price"] as! Int
                        let statusFood = value["statusFood"] as? String
                        let food = Food(id: id, name: namefood, price: pricefood, image: imagefood, note: notefood ,statusFood: statusFood)
                        self.foods.append(food)
                    }
                }
            }
            self.strFood = self.foods
            self.tableView.reloadData()
        }
    }
    
    func getDrinkData(){
        Defined.ref.child("Account").child(idAdmin ?? "").child("Menu/Drink").observe(DataEventType.value) { (DataSnapshot) in
            if let snapshort = DataSnapshot.children.allObjects as? [DataSnapshot]{
                self.foods.removeAll()
                for snap in snapshort {
                    let id = snap.key
                    if let value = snap.value as? [String: Any] {
                        let namefood = value["namefood"] as? String
                        let imagefood = value["imagefood"] as? String
                        let notefood = value["notefood"] as? String
                        let pricefood = value["price"] as? Int
                        let statusFood = value["statusFood"] as? String
                        let food = Food(id: id, name: namefood, price: pricefood, image: imagefood, note: notefood,statusFood: statusFood)
                        self.foods.append(food)
                    }
                }
                self.strFood = self.foods
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController:  UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strFood.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuCell.loadCell(tableView) as! MenuCell
        cell.setUp(data: strFood[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailFoodViewController") as! DetailFoodViewController
        let fd = strFood[indexPath.row]
        vc.content = fd.note ?? ""
        vc.img = fd.image ?? ""
        vc.name = fd.name ?? ""
        vc.price = String(fd.price!)
        vc.idFood = fd.id ?? ""
        vc.statusMenu = status
        vc.statusFood = fd.statusFood ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            strFood = foods
        } else {
            strFood = foods.filter {$0.name!.lowercased().contains(searchController.searchBar.text!.lowercased())}
        }
        tableView.reloadData()
    }
}

