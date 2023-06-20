//
//  ViewController.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginOulet: UITextField!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var errorOutlet: UILabel!
    
    var autoriz: EnumAuthorization?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        autoriz = nil
        loginOulet.text = ""
        passwordOutlet.text = ""
        errorOutlet.text = ""
    }
    
    func authorization() {
        if (loginOulet.text == "admin") && (passwordOutlet.text == "1111") {
            autoriz = .admin
        } else if (loginOulet.text == "simpleUser") && (passwordOutlet.text == "2222") {
            autoriz = .simpleUser
        } else if (loginOulet.text == "advancedUser") && (passwordOutlet.text == "3333") {
            autoriz = .advancedUser
        }

    }

    @IBAction func authorizationDidTap(_ sender: Any) {
        authorization()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: String(describing: AdminController.self)) as? AdminController else { return }
        switch autoriz {
            case .admin:
                vc.autoriz = autoriz
                navigationController?.pushViewController(vc, animated: true)
            case .simpleUser:
                vc.autoriz = autoriz
                navigationController?.pushViewController(vc, animated: true)
            case .advancedUser:
                vc.autoriz = autoriz
                navigationController?.pushViewController(vc, animated: true)
            case .none:
                self.errorOutlet.text = "Неверный логин или пароль"
                UIView.animate(withDuration: 0.5, animations: {
                    self.errorOutlet.alpha = 1.0
                }) { (finished) in
                    UIView.animate(withDuration: 0.5, delay: 2.0, options: [], animations: {
                        self.errorOutlet.alpha = 0.0
                    }, completion: nil)
                }
            }
    }
    
}
    


