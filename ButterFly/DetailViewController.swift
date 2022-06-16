//
//  DetailViewController.swift
//  ButterFly
//
//  Created by Yan Wang on 14/06/2022.
//

import Foundation
import UIKit

class DetailViewController : UIViewController {
    
    // MARK: TableView DataSource & Delegate Methods
    
    var detailView : DetailView?
    var order_id : Int64?
    var order : PurchaseOrder?
    var alert : UIAlertController?
    
    override func viewWillAppear(_ animated: Bool) {
        detailView = DetailView(frame: self.view.frame, style: .insetGrouped)
        detailView?.purchase_id = order_id
        detailView?.delegate = detailView
        detailView?.dataSource = detailView
        detailView?.purchase_order = order
        detailView?.fetchPurchaseOrder()
        self.view.addSubview(detailView!)
    }
    
    override func viewDidLoad() {
        self.navigationBarSetup()
    }
    
    // Set up navigation bar
    func navigationBarSetup() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewItems))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc func addNewItems() {
        alert = UIAlertController(title: "New Items", message: "You can add a new item here by entering the purchase id", preferredStyle: .alert)
        self.alert!.addTextField { textField in
            textField.placeholder = "Enter item id (Number Only)"
            textField.keyboardType = .numberPad
            textField.tag = 0
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        self.alert!.addTextField { textField in
            textField.placeholder = "Quantity"
            textField.keyboardType = .numberPad
            textField.tag = 1
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            let itemIDTextField = self.alert!.textFields![0]
            let quantityTextField = self.alert!.textFields![1]
            
            if (itemIDTextField.text?.count == 0 || itemIDTextField.text?.count == 0 ) {
                action.isEnabled = false
            }
            
            if self.order!.purchased_items!.contains(where: {item in
                (item as! Item).item_id == Int64(itemIDTextField.text!)!
            }) {
                
            }
            else {
                
            }
            
            let newItem = Item(context: self.detailView!.dataManager.context!)
            
            newItem.item_id = (Int64(itemIDTextField.text!))!
            newItem.quantity = (Int64(quantityTextField.text!))!
            newItem.order = self.order
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSS'Z'"
            self.order?.last_updated = dateFormatter.string(from: Date())
            newItem.last_updated = dateFormatter.string(from: Date())
            
            self.order?.addToPurchased_items(newItem)
            
            do {
                try self.detailView?.dataManager.context!.save()
            }
            catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
            self.detailView?.reloadData()
        }
        submitButton.isEnabled = false
        self.alert!.addAction(submitButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        self.alert!.addAction(cancelButton)
        
        self.present(self.alert!, animated: true, completion: nil)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        
        for textField in alert!.textFields!{
            if(textField.text!.count == 0){
                alert?.actions[0].isEnabled = false
                break
            }
            else {
                alert?.actions[0].isEnabled = true
            }
        }
    }
}
