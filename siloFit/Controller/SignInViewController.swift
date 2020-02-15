//
//  SignInViewController.swift
//  siloFit
//
//  Created by Ankur Sehdev on 12/02/20.
//  Copyright © 2020 Munish. All rights reserved.
//

import UIKit
import FacebookCore
import FacebookLogin
import FBSDKLoginKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func fbLoginAction(_ sender: Any) {
        
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn(permissions: [ .publicProfile, .email ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success( _, _, let accessToken):
                print("Logged in!\(accessToken.tokenString)")
                
                if((AccessToken.current) != nil){
                    
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)

                    Auth.auth().signIn(with: credential) { (authResult, error) in
                      if let error = error {
                        print(error)
                        return
                      }
                        
                    self.performSegue(withIdentifier: "homeSegue", sender: nil)

                    }
                    
//                    GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, email, gender"]).start(completionHandler: { (connection, result, error) -> Void in
//                        if (error == nil){
//                            let fbData = result as? [String:Any] ?? [:]
//                            print(fbData)
////                            self.AFLoginCall(data: fbData)
//                        }
//                    })
                    
                }
            }
            
            
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
