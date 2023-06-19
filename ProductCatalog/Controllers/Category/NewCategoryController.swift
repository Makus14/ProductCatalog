//
//  NewCategoryController.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import UIKit

class NewCategoryController: UIViewController {
    @IBOutlet weak var newCategoryOutlet: UITextField!
    
    private var existCategory: CategoryModel?
    
    var updateBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
     
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func viewDidTap() {
        self.dismiss(animated: true)
    }

    @IBAction func createCategoryDidTap(_ sender: Any) {
        guard !newCategoryOutlet.text.isEmptyOrNil else { return }
        let category = CategoryModel(name: newCategoryOutlet.text!)
        RealmManager<CategoryModel>().write(object: category)
        self.dismiss(animated: true)
        updateBlock?()
    }
    

}
