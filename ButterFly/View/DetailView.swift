//
//  DetailView.swift
//  ButterFly
//
//  Created by Milo on 15/06/2022.
//

import Foundation
import UIKit
import CoreData

class DetailView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    let dataManager = DataManager()

    var purchase_id : Int64?
    var purchase_order : PurchaseOrder?
    
    func fetchPurchaseOrder () {
        dataManager.context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        dataManager.context?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
    
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
            print("Detail TableView Reloaded")
        #endif
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss.SSS"
        var content = cell.defaultContentConfiguration()
        cell.selectionStyle = .none
        if indexPath.section == 0 {
            content.text = """
                Item ID: \((self.purchase_order?.purchased_items?.array[indexPath.row] as! Item).item_id)
                Item Quantity: \((self.purchase_order?.purchased_items?.array[indexPath.row] as! Item).quantity)
                """
        }
        else if indexPath.section == 1{
            content.text = """
            Invoice Number: \((self.purchase_order?.invoice?.invoice_number) ?? "0")
            Received status: \((self.purchase_order?.invoice?.received_status) ?? 0)
            """
        }
        cell.contentConfiguration = content
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0) {
            return self.purchase_order?.purchased_items?.count ?? 0
        }
        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Items"
        }
        else {
            return "Invoice"
        }
    }
}
