//
//  ProductCatalogCell.swift
//  ProductCatalog
//
//  Created by Mac on 16/06/2023.
//

import UIKit

class ProductCatalogCell: UITableViewCell {
    static let id = String(describing: ProductCatalogCell.self)
    
    @IBOutlet weak var productNameOutlet: UILabel!
    @IBOutlet weak var productDescriptionOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var generalNoteOutlet: UILabel!
    @IBOutlet weak var specialNoteOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
     
    func set(product: ProductModel) {
        productNameOutlet.text = product.productName
        productDescriptionOutlet.text = product.productDescription
        priceOutlet.text = "Цена: \(product.price) руб."
        generalNoteOutlet.text = product.generalNote
        specialNoteOutlet.text = product.specialNote

    }
    
    func set(productName: String, productDescription: String, price: Int, generalNote: String, specialNote: String) {
        productNameOutlet.text = productName
        productDescriptionOutlet.text = productDescription
        priceOutlet.text = "Цена: \(price) руб."
        generalNoteOutlet.text = generalNote
        specialNoteOutlet.text = specialNote
        
    }

}
