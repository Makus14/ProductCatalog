//
//  AdminController.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import UIKit

class AdminController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCategoryOutlet: UIButton!
    
    var productCategory: CategoryModel?
    var autoriz: EnumAuthorization?
    var category = RealmManager<CategoryModel>().read()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        registerCell()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        roleCheck()
    }
    
    func roleCheck() {
        switch autoriz {
            case .admin:
                addCategoryOutlet.isHidden = false
            case .simpleUser:
                addCategoryOutlet.isHidden = true
            case .advancedUser:
                addCategoryOutlet.isHidden = true
            case .none:
                print("error")
        }
    }
    
    func registerCell() {
        let nib = UINib(nibName: ProductCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ProductCell.id)
    }
    
    @IBAction func createNewCategoryAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: NewCategoryController.self)) as? NewCategoryController else { return }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        
        vc.updateBlock = { [weak self] in
            self?.category = RealmManager<CategoryModel>().read()
            self?.tableView.reloadData()
        }
        
        present(vc, animated: true)
    }
    
    @IBAction func exitAccountAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goToSearchController(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: SearchController.self)) as? SearchController else { return }
    
        vc.autoriz = autoriz
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}

extension AdminController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductCell.id, for: indexPath)
        guard let categoryCell = cell as? ProductCell else { return cell }
        categoryCell.set(category: category[indexPath.row])
        
        //vc.set(person: person)
        
        return categoryCell
    }
    
    
}

extension AdminController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if autoriz == .admin {
            return true
        } else {
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let categorys = category[indexPath.row]
            for i in categorys.products {
                RealmManager<ProductModel>().delete(object: i)
            }
            RealmManager<CategoryModel>().delete(object: categorys)
            category = RealmManager<CategoryModel>().read()
            tableView.reloadData()
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let category = category[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProductController") as! ProductController
        
        vc.set(category: category)
        vc.autoriz = autoriz
        
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
 
