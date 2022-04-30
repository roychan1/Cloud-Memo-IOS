//
//  RegisterViewController.swift
//  CloudMemo
//
//  Created by roy on 3/28/22.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.regular)]

        navigationItem.standardAppearance = barAppearance
    }

    @IBAction func RegisterButtonPressed(_ sender: UIButton) {
        
        if let email = usernameTextField.text, let password = passwordTextField.text {
            
            //still runs when username and password are blank
            Auth.auth().createUser(withEmail: email, password: password) { result, error in

                if let err = error {
                    //ERROR, not nil
                    self.showAlert(err.localizedDescription)
                } else {
                    //NO ERROR, nil
//                    Firestore.firestore().collection(K.Firestore.users).document(email).setData([:]) {err in
//
//                        if let e = err {
//                            print(e)
//                        }
//                    }

                    
                    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                        
                        if let err = error {
                            //ERROR, not nil
                            self!.showAlert(err.localizedDescription)
                        } else {
                            //NO ERROR, nil
                            
                            Firestore.firestore().collection(K.Firestore.users).document(Auth.auth().currentUser!.uid).setData([:]) {err in
                                
                                if let e = err {
                                    print(e)
                                }
                            }
                                                        
//                            Firestore.firestore().collection(K.Firestore.users).document(Auth.auth().currentUser!.uid).collection(K.Firestore.homeFolder)
                            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.register {
            if let directoryViewController = segue.destination as? DirectoryViewController {
                
                Firestore.firestore().collection(K.Firestore.homeFoldersPointer).document(K.Firestore.homeFolders).collection(Auth.auth().currentUser!.uid).document(Auth.auth().currentUser!.uid + K.Firestore.empty).setData([K.Firestore.type: K.Firestore.emptyType, K.Container.created: Date()])
                
                directoryViewController.currentCollection = Firestore.firestore().collection(K.Firestore.homeFoldersPointer).document(K.Firestore.homeFolders).collection(Auth.auth().currentUser!.uid)
            }
        }
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
