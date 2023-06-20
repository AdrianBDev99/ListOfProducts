//
//  AddProductsViewController.swift
//  ListOfProducts
//
//  Created by Adrian Bello Cahuantzi on 08/06/23.
//

import UIKit
import CoreData

class AddProductsViewController: UIViewController {
    
    // Nombres en ingles y no nombrar  outlets con la primera mayuscula
    @IBOutlet weak var Nombre: UITextField!
    
    @IBOutlet weak var Unidad: UISegmentedControl!
    
    @IBOutlet weak var Cantidad: UITextField!
    
    
    @IBOutlet weak var switchProduct: UISwitch!
    
    
    var products = [ProductsModel]()
    var unitProduct = ""

    
        override func viewDidLoad() {
        super.viewDidLoad()
        self.unitProduct = Unidad.titleForSegment(at: Unidad.selectedSegmentIndex) ?? ""
            
            switchProduct.isOn = false
            Cantidad.isHidden = true
        
    }
    func saveProduct(name:String, unit: String, quantity: Double, isOnSwitch: Bool){
        let manageContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        let productCD = Product(context: manageContext)
        productCD.setValue(name, forKey: #keyPath(Product.nombre))
        productCD.setValue(unit, forKey: #keyPath(Product.unidad))
        productCD.setValue(quantity, forKey: #keyPath(Product.cantidad))
        
        
        
        if isOnSwitch {
            addToList(product: productCD)
            let itemProduct = ProductList (context: manageContext)
            itemProduct.addToProducts(productCD)
        }

            
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
    }
    

    
    
    
    @IBAction func addProduct(_ sender: UIButton) {
        
        let isOnSwitch = switchProduct.isOn
        
        saveProduct(name: Nombre.text ?? "", unit:self.unitProduct, quantity: Double(Cantidad.text ?? "0.0") ?? 0.0, isOnSwitch: isOnSwitch)
        
       
        
        
        let alertAddProduct = UIAlertController(title: "Producto agregado", message: "Tu producto se agrego con exito", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
            self.dismiss(animated: true, completion: nil)
            
        }
        alertAddProduct.addAction(action)
        self.present(alertAddProduct, animated: true, completion: nil)
        
        
    }
    func addToList(product: Product){
        
    }
    
    
    @IBAction func selectUnit(_ sender: UISegmentedControl) {
        let unit = sender.titleForSegment(at: sender.selectedSegmentIndex)
        self.unitProduct = unit ?? ""
        
        
        
    }
    
   
    
    @IBAction func Switch(_ sender: UISwitch) {
        if sender.isOn {
            Cantidad.isHidden = false
        } else {
            self.Cantidad.isHidden = true
        }
    }
    
       
    
    @IBAction func Cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
       
    }
}
