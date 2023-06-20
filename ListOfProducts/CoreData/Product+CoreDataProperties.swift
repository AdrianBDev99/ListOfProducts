//
//  Product+CoreDataProperties.swift
//  ListOfProducts
//
//  Created by Adrian Bello Cahuantzi on 14/06/23.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var cantidad: Double
    @NSManaged public var nombre: String?
    @NSManaged public var unidad: String?
    @NSManaged public var productList: ProductList?

}

extension Product : Identifiable {

}
