//
//  SignInViewController.swift
//  CloudMemo
//
//  Created by roy on 3/28/22.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
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

    
    @IBAction func signInButtonPressed(_ sender: UIButton) {
        if let email = usernameTextField.text, let password = passwordTextField.text {
            
            //still runs when username and password are blank
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in

                if let err = error {
                    //ERROR, not nil
                    let alert = UIAlertController(title: "", message: err.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self!.present(alert, animated: true, completion: nil)
                } else {
                    //NO ERROR, nil
                    self!.performSegue(withIdentifier: K.Segue.login, sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.login {
            if let directoryViewController = segue.destination as? DirectoryViewController {
                directoryViewController.currentCollection = Firestore.firestore().collection(K.Firestore.homeFoldersPointer).document(K.Firestore.homeFolders).collection(Auth.auth().currentUser!.uid)
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
