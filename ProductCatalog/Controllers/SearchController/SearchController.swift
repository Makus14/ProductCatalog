//
//  SearchController.swift
//  ProductCatalog
//
//  Created by Mac on 17/06/2023.
//

import UIKit

class SearchController: UIViewController {
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var category: CategoryModel?
    var autoriz: EnumAuthorization?
    var products = RealmManager<ProductModel>().read()
    
    var massProducts = [ProductModel]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var massSearch = [ProductModel]() {
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
        getProducts()
        self.searchView.layer.borderWidth = 0.2
        self.searchView.layer.cornerRadius = 12
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        products = RealmManager<ProductModel>().read()
        tableView.reloadData()
       
    }
    
    private func getProducts() {
                    var i: Int = 0
                    for _ in products {
                        self.massProducts.append(products[i])
                        i = i + 1
                    }
                    self.massSearch = self.massProducts
        
            }
    
    func registerCell() {
        let nib = UINib(nibName: ProductCatalogCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductCatalogCell.id)
    }
    
    @IBAction func searchDidTap(_ sender: Any) {
        massSearch.removeAll()
            let text = self.searchTextField.text!.lowercased()
        for search in massProducts {
            if text == "" {
                let isArrayContains = search.productName.lowercased()
                if isArrayContains != nil {
                    self.massSearch.append(search)
                }
            } else {
                let isArrayContains = search.productName.lowercased().range(of: text)
                if isArrayContains != nil {
                    self.massSearch.append(search)
                }
            }
        }
        
    }
    
    @IBAction func returnDidTap(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
}

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return massSearch.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCatalogCell.id, for: indexPath)
        guard let productCell = cell as? ProductCatalogCell else { return cell }
            
            let productName = String(massSearch[indexPath.row].productName)
            let productDescription = String(massSearch[indexPath.row].productDescription)
            let price = Int(massSearch[indexPath.row].price)
            let generalNote = String(massSearch[indexPath.row].generalNote)
            let specialNote = String(massSearch[indexPath.row].specialNote)
            
            productCell.set(productName: productName, productDescription: productDescription, price: price, generalNote: generalNote, specialNote: specialNote)
        
            if autoriz == .simpleUser {
                productCell.specialNoteOutlet.isHidden = true
            }
        
        return productCell
    }
    
}

extension SearchController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
