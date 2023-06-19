//
//  ProductCell.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import UIKit

class ProductCell: UITableViewCell {
    static let id = String(describing: ProductCell.self)
    
    @IBOutlet weak var nameOfCategory: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func set(category: CategoryModel) {
        nameOfCategory.text = "\(category.name)"
        
    }
    
}
