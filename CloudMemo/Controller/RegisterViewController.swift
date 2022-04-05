//
//  RegisterViewController.swift
//  CloudMemo
//
//  Created by roy on 3/28/22.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }

    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        
        if let username = usernameTextField.text, let password = passwordTextField.text {
            
            //still runs when username and password are blank
            Auth.auth().createUser(withEmail: username, password: password) { result, error in

                if let err = error {
                    //ERROR, not nil
                    self.showAlert(err.localizedDescription)
                } else {
                    //NO ERROR, nil
                    Auth.auth().signIn(withEmail: username, password: password) { [weak self] authResult, error in
                        
                        if let err = error {
                            //ERROR, not nil
                            self!.showAlert(err.localizedDescription)
                        } else {
                            //NO ERROR, nil
                            self!.performSegue(withIdentifier: K.Segue.register, sender: self)
                        }
                    }
                }
            }
        }
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
