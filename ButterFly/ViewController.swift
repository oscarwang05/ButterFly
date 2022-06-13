//
//  ViewController.swift
//  ButterFly
//
//  Created by Yan Wang on 13/06/2022.
//

import UIKit
import Alamofire
import CoreData

let url = "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders"

class ViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var info = [Dictionary<String, Any>]()
    var infoInView : [PurchaseOrder]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.fetchData()
        
    }
    
    // Set up navigation bar
    func navigationBarSetup() {
        
    }
    
    func fetchData () {
        let request = AF.request(url)
        request.responseData { data in
            do {
                self.info = try (JSONSerialization.jsonObject(with: data.data!) as? [Dictionary])!
            }
            catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
                
            do {
                self.infoInView = try self.context.fetch(PurchaseOrder.fetchRequest())
            }
            catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: TableView Delegate & DataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

}

