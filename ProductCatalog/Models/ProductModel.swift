//
//  ProductModel.swift
//  ProductCatalog
//
//  Created by Mac on 16/06/2023.
//

import Foundation
import RealmSwift

class ProductModel: Object {
    @objc dynamic var productName: String = ""
    @objc dynamic var productDescription: String = ""
    @objc dynamic var price: Int = 0
    @objc dynamic var generalNote: String = ""
    @objc dynamic var specialNote: String = ""
    @objc dynamic var ownerID = ""
    
    convenience init(productName: String, productDescription: String, price: Int, generalNote: String, specialNote: String, ownerID: String) {
        self.init()
        self.productName = productName
        self.productDescription = productDescription
        self.price = price
        self.generalNote = generalNote
        self.specialNote = specialNote
        self.ownerID = ownerID
    }
}
