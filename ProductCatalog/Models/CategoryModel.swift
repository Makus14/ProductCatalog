//
//  CategoryModel.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import Foundation
import RealmSwift

class CategoryModel: Object {
    @objc dynamic var id = ""
    @objc dynamic var name: String = ""
    
    var products: [ProductModel] {
            let allProducts = RealmManager<ProductModel>().read()
            let categoryProduct = allProducts.filter {$0.ownerID == self.id }
            return categoryProduct
    }
    
    convenience init(name: String) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
    }
}
