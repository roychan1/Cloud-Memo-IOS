//
//  FileViewController.swift
//  CloudMemo
//
//  Created by roy chan on 4/24/22.
//

import Foundation
import UIKit
import Firebase

class FileViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var currentCollection : CollectionReference!
    var name : String!
    var content : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = name
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.tintColor = UIColor.white
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = UIColor(red: CGFloat(178/255.0), green: CGFloat(154/255.0), blue: CGFloat(118/255.0), alpha: CGFloat(1.0))
        barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = navigationItem.standardAppearance
        
        
        let doc = currentCollection.document(name)
        doc.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let dataDescription = document.get(K.Container.File.content) as? String
                self.textView.text = dataDescription
            } else {
                print("Document does not exist")
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Save changes?", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default) {_ in
            self.saveText()
            
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "No", style: .default) {_ in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveText() {
        if textView.hasText {
            currentCollection.document(name).updateData([K.Container.File.content: textView.text ?? ""])
        } else {
            print("Text View is empty")
        }
    }
}
