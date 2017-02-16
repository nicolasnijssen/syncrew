//  Syncrew
//
//  Created by Nicolas Nijssen
//  Copyright © 2017 nicolas. All rights reserved.
//

import UIKit


class LaunchViewController: UIViewController {
   

    func pushTo(viewController: ViewControllerType)  {
        switch viewController {
            
        case .home:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeScreen") as! ViewController
            
            let nc = UINavigationController(rootViewController: vc)

            self.present(nc, animated: false, completion: nil)
            
        case .login:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login") as! LoginViewController
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    //Check if user is signed in or not
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
           
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
           
            User.loginUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async {
                    if status == true {
                        weakSelf?.pushTo(viewController: .home)
                    } else {
                        weakSelf?.pushTo(viewController: .login)
                    }
                    weakSelf = nil
                }
            })
            
        } else {
            self.pushTo(viewController: .login)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
