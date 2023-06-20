//
//  ProductController.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import UIKit

class ProductController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addProductOutlet: UIButton!
    @IBOutlet weak var sortedButtonOutlet: UIButton!
    
    var category: CategoryModel?
    var autoriz: EnumAuthorization?
    var products = RealmManager<ProductModel>().read()
    var massSorted = [ProductModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products = RealmManager<ProductModel>().read()
        navigationController?.isNavigationBarHidden = true
        
        tableView.reloadData()
        roleCheck()
        getProducts()
        sortedButtonOutlet.tintColor = UIColor(red: 0/255, green: 112/255, blue: 53/255, alpha: 1)
        
    }
    
    private func getProducts() {
        self.massSorted = category!.products
        tableView.reloadData()
    }
    
    func roleCheck() {
        switch autoriz {
            case .admin:
                addProductOutlet.isHidden = false
            case .simpleUser:
                addProductOutlet.isHidden = true
            case .advancedUser:
                addProductOutlet.isHidden = false
            case .none:
                print("error")
        }
    }
 
    func set(category: CategoryModel) {
        self.category = category
    }
    
    func registerCell() {
        let nib = UINib(nibName: ProductCatalogCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductCatalogCell.id)
    }

    @IBAction func createNewProductAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: NewProductController.self)) as? NewProductController else { return }
        
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        guard let category = category else { return }
        vc.set(ownerID: category.id)
        vc.updateProductBlock = { [weak self] in
            self?.products = RealmManager<ProductModel>().read()
            self?.tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func sortedByPriceDidTap(_ sender: UIButton) {
        if sender.tintColor == UIColor.green {
            for _ in category!.products {
                self.massSorted = (category?.products.sorted( by: { $0.price > $1.price }))!
                
            }
            sender.tintColor = UIColor.red
        } else {
            for _ in category!.products {
                sender.tintColor = UIColor.red
                self.massSorted = (category?.products.sorted( by: { $0.price < $1.price }))!
            }
            sender.tintColor = UIColor.green
        }

}
    
    @IBAction func returnDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension ProductController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massSorted.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCatalogCell.id, for: indexPath)
        guard let productCell = cell as? ProductCatalogCell else { return cell }

        let productName = massSorted[indexPath.row].productName
        let productDescription = massSorted[indexPath.row].productDescription
        let price = massSorted[indexPath.row].price
        let generalNote = massSorted[indexPath.row].generalNote
        let specialNote = massSorted[indexPath.row].specialNote

        productCell.set(productName: productName, productDescription: productDescription, price: price, generalNote: generalNote, specialNote: specialNote)
        
        if autoriz == .simpleUser {
            productCell.specialNoteOutlet.isHidden = true
        }
        
        return productCell
    }
    
}

extension ProductController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if autoriz == .admin {
            return true
        } else if autoriz == .advancedUser {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = massSorted[indexPath.row]
            RealmManager<ProductModel>().delete(object: product)

            massSorted.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = massSorted[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vcProduct = storyboard.instantiateViewController(withIdentifier: String(describing: NewProductController.self)) as? NewProductController else { return }
        vcProduct.autoriz = autoriz
        vcProduct.set(type: .edit, product: category)
        tableView.reloadData()
        
        if autoriz == .admin || autoriz == .advancedUser {
            navigationController?.pushViewController(vcProduct, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
