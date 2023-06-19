//
//  NewProductController.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import UIKit

class NewProductController: UIViewController {
    @IBOutlet weak var nameProductOutlet: UITextField!
    @IBOutlet weak var descriptionOutlet: UITextField!
    @IBOutlet weak var priceOutlet: UITextField!
    @IBOutlet weak var generalNoteOutlet: UITextField!
    @IBOutlet weak var specialNoteOutlet: UITextField!
    
    private var owner: String?
    var updateProductBlock: (() -> Void)?
    var autoriz: EnumAuthorization?
    var product: ProductModel?
    
    private var controllerType: ProductEnum = .create
    private var existProduct: ProductModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGesture()
        guard existProduct != nil, controllerType == .edit else { return }
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func set(type: ProductEnum , product: ProductModel? = nil) {
        self.controllerType = type
        self.existProduct = product
    }
    
    func setupData() {
        guard let existProduct = existProduct else {
            return
        }
        nameProductOutlet.text = existProduct.productName
        descriptionOutlet.text = existProduct.productDescription
        priceOutlet.text = "\(existProduct.price)"
        generalNoteOutlet.text = existProduct.generalNote
        specialNoteOutlet.text = existProduct.specialNote
        self.owner = existProduct.ownerID

    }
    
    func set(ownerID: String) {
        self.owner = ownerID
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc private func viewDidTap() {
        self.dismiss(animated: true)
    }

    @IBAction func createProductDidTap(_ sender: Any) {
        guard !nameProductOutlet.text.isEmptyOrNil, !descriptionOutlet.text.isEmptyOrNil, !priceOutlet.text.isEmptyOrNil, !generalNoteOutlet.text.isEmptyOrNil, !specialNoteOutlet.text.isEmptyOrNil,
              let text = priceOutlet.text, let price = Int(text), let owner = owner
        else { return }

        switch controllerType {
            case .create:
                let product = ProductModel(productName: nameProductOutlet.text!, productDescription: descriptionOutlet.text!, price: price, generalNote: generalNoteOutlet.text!, specialNote: specialNoteOutlet.text!, ownerID: owner)
                RealmManager<ProductModel>().write(object: product)
                updateProductBlock?()
                //dismiss(animated: true)
                //self.navigationController?.popViewController(animated: true)
            case .edit:
                guard let existProduct = existProduct else { return }
                RealmManager<ProductModel>().update { realm in
                    try? realm.write {
                        existProduct.productName = self.nameProductOutlet.text!
                        existProduct.productDescription = self.descriptionOutlet.text!
                        existProduct.generalNote = self.generalNoteOutlet.text!
                        existProduct.specialNote = self.specialNoteOutlet.text!
                        existProduct.price = price
                       
                    }
                    
                }
               
                //self.navigationController?.popViewController(animated: true)
                updateProductBlock?()
        }
        //dismiss(animated: true)
        //updateProductBlock?()
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
