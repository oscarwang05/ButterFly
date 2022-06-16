//
//  ViewController.swift
//  ButterFly
//
//  Created by Yan Wang on 13/06/2022.
//

import UIKit
import Alamofire
import CoreData
import SwiftyJSON

class OrderViewController: UIViewController {
    
    var orderView : OrderView?
    var alert : UIAlertController?
    
    override func viewWillAppear(_ animated: Bool) {
        orderView?.dataManager.fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationBarSetup()
        
        orderView = OrderView(frame: self.view.frame, style: .insetGrouped)
        orderView?.dataSource = orderView
        orderView?.delegate = orderView
        self.view.addSubview(orderView!)
    }
    
    // Set up navigation bar
    func navigationBarSetup() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPurchaseOrder))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
    }
    
    @objc func emptyDataBase () {
        let array = ["PurchaseOrder", "Invoice", "Item", "Receipt"]
        for entity in array {
            let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
            do
            {
                try self.orderView!.dataManager.context!.execute(deleteRequest)
                try self.orderView!.dataManager.context!.save()
            }
            catch
            {
                print ("There was an error")
            }
        }
        DispatchQueue.main.async {
            self.orderView!.dataManager.fetchData()
        }
    }
    
    @objc func addNewPurchaseOrder() {
        alert = UIAlertController(title: "New Purchase Order", message: "You can add a new purchase order here by entering the purchase id", preferredStyle: .alert)
        self.alert!.addTextField { textField in
            textField.placeholder = "Enter purchase id (Number Only)"
            textField.keyboardType = .numberPad
            textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        }
        
        let submitButton = UIAlertAction(title: "Add", style: .default) { action in
            let textField = self.alert!.textFields![0]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            let last_updated = dateFormatter.string(from: Date())
            

            if self.orderView!.dataManager.localOrder!.contains(where: { order in
                order.order_id == Int64(textField.text!)!
            }) {
                let actionSheet = UIAlertController(title: "", message: "There is an entry with the same purchase order id, would you like to replace it?", preferredStyle: .actionSheet)
                let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
                    let newOrder = PurchaseOrder(context: self.orderView!.dataManager.context!)
                    newOrder.order_id = Int64(textField.text!)!
                    newOrder.last_updated = last_updated
                    
                    do {
                        try self.orderView!.dataManager.context!.save()
                    }
                    catch {
                        #if DEBUG
                        print(error.localizedDescription)
                        #endif
                    }
                    self.orderView!.dataManager.fetchLocalData()
                    self.orderView!.reloadData()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                
                actionSheet.addAction(confirmAction)
                actionSheet.addAction(cancelAction)
                
                self.present(actionSheet, animated: true)
            }
            else {
                let newOrder = PurchaseOrder(context: self.orderView!.dataManager.context!)
                newOrder.order_id = Int64(textField.text!)!
                newOrder.last_updated = last_updated
                
                do {
                    try self.orderView!.dataManager.context!.save()
                }
                catch {
                    #if DEBUG
                    print(error.localizedDescription)
                    #endif
                }
                self.orderView!.dataManager.fetchLocalData()
                self.orderView!.reloadData()
            }
            
        }
        submitButton.isEnabled = false
        alert!.addAction(submitButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert!.addAction(cancelButton)
        
        self.present(alert!, animated: true, completion: nil)
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if(textField.text!.count == 0){
            alert!.actions[0].isEnabled = false
        }
        else {
            alert?.actions[0].isEnabled = true
        }
    }
}

