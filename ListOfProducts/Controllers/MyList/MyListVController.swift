//
//  TableViewController.swift
//  ListOfProducts
//
//  Created by Adrian Bello Cahuantzi on 07/06/23.
//

import UIKit
import CoreData

class MyListVController: UITableViewController {
    
    var listProduct = [ProductList]()
    
    @IBOutlet var TableViewList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TableViewList.delegate = self
        TableViewList.dataSource = self
        deleteList()
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProductsOfList()
    }
    
    func setupButtomBar() {
        let deleteBtn = UIBarButtonItem (title: "Eliminar", style: .plain, target: self, action: #selector(showAlert))
        self.navigationItem.rightBarButtonItem = deleteBtn
    }
    
    func deleteList() {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        fetchRequest = NSFetchRequest(entityName: "ProductList")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let batchDelete = try? context.execute(deleteRequest) as? NSBatchDeleteResult
        
        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID]
        else {return}
        
        let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deleteResult]
        
        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [context])
        
    }

    
    func getProductsOfList() {
        let productsFetch: NSFetchRequest<ProductList> = ProductList.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(productsFetch)
            self.listProduct = results
            
            if listProduct.count > 0 {
                setupButtomBar()
            } else {
                self.navigationItem.rightBarButtonItem = nil
            }
            
            
            tableView.reloadData()
            debugPrint(results)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    @objc private func showAlert(){
        let alert = UIAlertController(title: "¿Deseas eliminar esta lista?", message: "Se eliminaran todos los productos de la lista ", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        
        
        let action = UIAlertAction(title: "Eliminar", style: .default) { (action) -> Void in
            
            //Invocar funcion para elminar
            self.deleteList()
            //Invocar funcion para obtener datos de la lista
            self.getProductsOfList()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listProduct.count == 0 {
            self.tableView.setEmptyMessage("No has agregado productos a la lista")
        } else {
            self.tableView.restore()
        }
        return listProduct.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell = UITableViewCell (style: .value1, reuseIdentifier: "cell")
        let obj = listProduct[indexPath.item]
        if let product = obj.products?.allObjects as? [Product]{
            cell.textLabel?.text = product.first?.nombre
            
            let cantidad = product.first?.cantidad ?? 0
            var unidad = product.first?.unidad ?? ""
            
            if cantidad < 2.0 {
                if unidad == "Pesos" {
                    unidad = "Peso"
                }
                if unidad == "Piezas" {
                    unidad = "Pieza"
                }
            }
            cell.detailTextLabel?.text = "\(cantidad) \(unidad)"
            
        }
        
        return cell
        
    }
    
    
}



extension MyListVController: ProductsOutput{
    func successProductsResponse(_ model: ProductsModel) {
        
        
    }
    
    func successProductsFailedResponse(_ message: String) {
        
    }
    
    
}
