This is a demo app. 
-------------------------------------------

Finished all required function as follows:
1.  initially populates its content from the data that comes from the server
2.  able to add local data to database  -- the data will not be overridden by the data in the server unless the last updated time in the server is greater than the last updated time on the local device
3.  Coredata database type: PurchaseOrder, Invoice, Item, Receipt
4.  Added a plus button on the Home Page that will display a screen to add a purchase order.
  -- An AlertViewController will pop and ask the user to insert the purchase id (number only) to create a new purchase order
  -- When the user is trying to create a new purchase order with an existing purchase order, a confirmation window will pop to make sure the user want to override the existing order

5.  Added a plus button on the Detail Page that will display a screen to add a new item to the current purchase order.
  -- An AlertViewController will pop and ask the user to insert the item id(number only) and quantity to create a new item
  -- When the user is trying to create a new item with an existing item id, a confirmation window will pop and ask whether the user would like to replace the new quantity with the old one or add the quantity on top of the existing item. 


