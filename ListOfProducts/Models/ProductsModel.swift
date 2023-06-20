//
//  ProductsModel.swift
//  ListOfProducts
//
//  Created by Adrian Bello Cahuantzi on 07/06/23.
//

import Foundation

protocol ProductsOutput: AnyObject {
    func successProductsResponse(_ model: ProductsModel)
    func successProductsFailedResponse(_ message: String)
}


struct ProductsModel: Decodable {
    let NombreDelProducto: String
    let Unidad: String
    let Cantidad: Double
}

class Products: NSObject {
    public static let shared = Products()
    private override init() {}
    var delegateProducts: ProductsOutput?
    
}
