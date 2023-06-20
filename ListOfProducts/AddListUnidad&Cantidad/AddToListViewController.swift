//
//  AddListCant&UniddViewController.swift
//  ListOfProducts
//
//  Created by Adrian Bello Cahuantzi on 09/06/23.
//

import UIKit
import CoreData

class AddToListViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameProductLbl: UILabel!
    @IBOutlet weak var addCantidad: UITextField!
    var productSelected: Product?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewUnit()
        self.addCantidad.keyboardType = UIKeyboardType.asciiCapableNumberPad
        
        
        
    }
    
    func setupView() {
        if let product = productSelected {
            self.nameProductLbl.text = product.nombre
        }
    }
    
    func setupViewUnit() {
        if let unit = productSelected {
            self.addCantidad.text = unit.unidad
        }
        
    }
    
    func addToList(){
        
        if let product = productSelected {
            product.cantidad = Double(addCantidad.text ?? "0.0") ?? 0.0
            
            
            let manageContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let itemList = ProductList(context: manageContext)
            itemList.addToProducts(product)
            AppDelegate.sharedAppDelegate.coreDataStack.saveContext()

        }
        
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
        
    }
    @IBAction func Agregar(_ sender: UIButton) {
        addToList()
        
        
        
        let alertAddCantUnidd = UIAlertController(title: "Producto agregado", message: "Tu producto se agrego con exito", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        alertAddCantUnidd.addAction(action)
        self.present(alertAddCantUnidd, animated: true, completion: nil)
    }
    
    @IBAction func Stepper(_ sender: UIStepper) {
        addCantidad.text = String(sender.value)
        
        
    }
    
     
    
}
