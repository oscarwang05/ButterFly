//
//  DataManager.swift
//  ButterFly
//
//  Created by Milo on 15/06/2022.
//

import Foundation
import Alamofire
import SwiftyJSON
import UIKit
import CoreData

class DataManager {
    var context : NSManagedObjectContext?
    var localOrder : [PurchaseOrder]?
    
    func fetchData () {
        context = nil
        context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context?.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.fetchLocalData()
        self.fetchRemoteData()
    }
    
    func fetchLocalData () {
        do {
            self.localOrder = try self.context?.fetch(PurchaseOrder.fetchRequest())
        }
        catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
    }
    
    func fetchRemoteData () {
        let request = AF.request(url)
        request.responseData { data in
            do {
                let remoteInfo = try JSON(data: data.data!)
                
                for remoteOrder in remoteInfo {
                    if self.localOrder!.contains(where: { order in
                        if((order.order_id == remoteOrder.1["id"].int64Value) && ((order.last_updated?.toDate())! < (remoteOrder.1["last_updated"].stringValue.toDate()))) {
                            self.context!.delete(order)
                            // TODO: Need to do something after deleting local order
                            self.createOrderFrom(remoteOrder.1)
                        }
                        return order.order_id == remoteOrder.1["id"].int64Value
                    }) {
                        
                    }
                    else {
                        self.createOrderFrom(remoteOrder.1)
                    }
                }
                
                DispatchQueue.main.async {
                    let views =  ((UIApplication.shared.connectedScenes.first as! UIWindowScene).windows[0].rootViewController as! UINavigationController).visibleViewController!.view.subviews
                    for view in views {
                        if view is UITableView {
                            (view as! UITableView).reloadData()
                        }
                    }
                }

            }
            catch {
                #if DEBUG
                print(error.localizedDescription)
                #endif
            }
        }
    }
    
    func createOrderFrom(_ order : JSON) {
        let remotePurchaseOrder = PurchaseOrder(context: self.context!)
        
        remotePurchaseOrder.order_id = order["id"].int64Value
        remotePurchaseOrder.last_updated = order["last_updated"].stringValue
        remotePurchaseOrder.purchase_order_number = order["purchase_order_number"].stringValue
        remotePurchaseOrder.supplier_id = order["supplier_id"].int64Value
        
        for item in order["items"] {
            let purchased_item = Item(context: self.context!)
            purchased_item.item_id = item.1["id"].int64Value
            purchased_item.last_updated = item.1["last_updated"].stringValue
            purchased_item.active_flag = item.1["active_flag"].boolValue
            purchased_item.last_updated_user_entity_id = item.1["last_updated_user_entity_id"].int64Value
            purchased_item.product_item_id = item.1["product_item_id"].int64Value
            purchased_item.quantity = item.1["quantity"].int64Value
            purchased_item.transient_identifier = item.1["transient_identifier"].int64Value
            purchased_item.order = remotePurchaseOrder
            
            remotePurchaseOrder.addToPurchased_items(purchased_item)
        }
        
        let invoice = order["invoices"][0]
        
        remotePurchaseOrder.invoice = Invoice(context: self.context!)
        
        remotePurchaseOrder.invoice?.invoice_id = invoice["id"].int64Value
        remotePurchaseOrder.invoice?.last_updated_user_entity_id = invoice["last_updated_user_entity"].int64Value
        remotePurchaseOrder.invoice?.last_updated = invoice["last_updated"].stringValue
        remotePurchaseOrder.invoice?.invoice_number = invoice["invoice_number"].stringValue
        remotePurchaseOrder.invoice?.created = invoice["created"].stringValue
        remotePurchaseOrder.invoice?.received_status = invoice["received_status"].int64Value
        remotePurchaseOrder.invoice?.order = remotePurchaseOrder
        
        remotePurchaseOrder.invoice?.receipts = Receipt(context: self.context!)
        
        remotePurchaseOrder.invoice?.receipts?.receipt_id = invoice["receipt"][0]["id"].int64Value
        remotePurchaseOrder.invoice?.receipts?.product_item_id = invoice["receipt"][0]["product_item_id"].int64Value
        remotePurchaseOrder.invoice?.receipts?.received_quantity = invoice["receipt"][0]["received_quantity"].int64Value
        remotePurchaseOrder.invoice?.receipts?.created = invoice["receipt"][0]["created"].stringValue
        remotePurchaseOrder.invoice?.receipts?.last_updated_user_entity_id = invoice["receipt"][0]["last_updated_user_entity_id"].int64Value
        remotePurchaseOrder.invoice?.receipts?.transient_identifier = invoice["receipt"][0]["transient_identifier"].stringValue
        remotePurchaseOrder.invoice?.receipts?.sent_date = invoice["receipt"][0]["sent_date"].stringValue
        remotePurchaseOrder.invoice?.receipts?.active_flag = invoice["receipt"][0]["active_flag"].boolValue
        remotePurchaseOrder.invoice?.receipts?.last_updated = invoice["receipt"][0]["last_updated"].stringValue
        remotePurchaseOrder.invoice?.receipts?.invoice = remotePurchaseOrder.invoice ?? nil
        
        
        do {
            try self.context!.save()
        }
        catch {
            #if DEBUG
            print(error.localizedDescription)
            #endif
        }
        self.fetchLocalData()
    }
}
