//
//  OrderView.swift
//  ButterFly
//
//  Created by Milo on 14/06/2022.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import CoreData

let url = "https://my-json-server.typicode.com/butterfly-systems/sample-data/purchase_orders"

class OrderView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let dataManager = DataManager()

    // MARK: - Overrides Methods
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: TableView Datasource and Delegate Methods
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        #if DEBUG
        print("Order TableView Reloaded")
        #endif
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss.SSS"
        
        switch(indexPath.row){
        case 0:
            var content = cell.defaultContentConfiguration()
            content.text = """
                Purchase Order ID: \(self.dataManager.localOrder?[indexPath.section].order_id ?? 0)
                No of items: \(self.dataManager.localOrder?[indexPath.section].purchased_items?.count ?? 0)
                Last updated time : \(dateFormatter.string(from: (self.dataManager.localOrder?[indexPath.section].last_updated?.toDate())!))
                """
            cell.contentConfiguration = content
            break
        default:
            cell.selectionStyle = .none
            break
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dataManager.localOrder?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        viewController.order_id = self.dataManager.localOrder?[indexPath.section].order_id
        viewController.order = self.dataManager.localOrder?[indexPath.section]
        
        
        (self.window?.rootViewController as! UINavigationController).pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
