//
//  ViewController.swift
//  ListOfProducts
//
//  Created by Adrian Bello Cahuantzi on 07/06/23.
//

import UIKit
import CoreData

class MyProductsVController: UIViewController {
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    var listProduct = [Product]()
    
    var valueToPass: Double = 0.0
    
    var productFilter:[Product]!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtomBar()
       
        
        //Definiendo el delegado del searchBar
        searchBar.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getProducts()
    }
    
    
    
    func getProducts() {
        let productsFetch: NSFetchRequest<Product> = Product.fetchRequest()
        do {
            let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try managedContext.fetch(productsFetch)
            self.listProduct = results
            productFilter = listProduct
            tableView.reloadData()
            debugPrint(results)
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
    }
    
    func setupButtomBar() {
        let add = UIBarButtonItem (barButtonSystemItem: .add, target: self, action: #selector(addProduct))
        navigationItem.rightBarButtonItems = [add]
        add.tintColor = UIColor.red
        
    }
    @objc func addProduct() {
        let loginVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddProductsViewController") as! AddProductsViewController
        //self.navigationController?.pushViewController(loginVC, animated: true)
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    
    
    
}
extension MyProductsVController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productFilter.count == 0 {
            self.tableView.setEmptyMessage("Aun no existen productos")
        } else {
            self.tableView.restore()
        }
        return productFilter.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let obj = productFilter[indexPath.item]
        cell.textLabel?.text = obj.nombre
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddToListViewController") as? AddToListViewController {
            vc.productSelected = productFilter[indexPath.item]
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
    }
}

extension MyProductsVController: ProductsOutput {
    func successProductsResponse(_ model: ProductsModel) {
    }
    
    func successProductsFailedResponse(_ message: String) {
    }
    
    
}

extension MyProductsVController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        productFilter = []
        if searchText == ""{
            productFilter = listProduct
        }
        for productItem in listProduct {
            let product = productItem.nombre ?? ""
            if product.contains(searchText){
                productFilter.append(productItem)
            }
        }
        self.tableView.reloadData()
    }
    
}
