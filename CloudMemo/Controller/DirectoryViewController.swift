//
//  DirectoryViewController.swift
//  CloudMemo
//
//  Created by roy on 3/30/22.
//

import UIKit
import Firebase

class DirectoryViewController: UITableViewController {
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //array of folders and/or files
    var containers : [Container] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Home"
        
        let signOut = signOutButton.customView as? UIButton
        signOut?.setTitle("Sign Out", for: .normal)
        
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.rowHeight = 60
        
        setUpAddMenu()
        loadCells()
    }
    
    func setUpAddMenu() {
        let newFile = UIAction(title: "New File", image: nil) { _ in
            
            self.makeNewFile()
        }
        let newFolder = UIAction(title: "New Folder", image: nil) { _ in
            
            self.makeNewFolder()
        }
        
        let addMenu = UIMenu(title: "", children: [newFolder, newFile])
        
        navigationItem.rightBarButtonItem = .init(systemItem: .add)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.menu = addMenu
    }
    
    func makeNewFile() {
        
    }
    
    func makeNewFolder() {
        let alert = UIAlertController(title: "Enter folder name", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Create", style: .default) {_ in
            
            if let user = Auth.auth().currentUser?.email {
                if alert.textFields?[0].text != "" {
                    Firestore.firestore().collection(user + (alert.textFields?[0].text)! + K.Firestore.folder).addDocument(data: [K.Folder.name: (alert.textFields?[0].text)!, K.Folder.contains: []]) { (error) in
                        
                        if let err = error {
                            print(err)
                        } else {
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
                            alert.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ContainerCell
        
        cell.titleLabel.text = containers[indexPath.row].name
        
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Sign Out", message: "Would you like to sign out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            
            do {
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
            } catch {
                print(error)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {_ in
            
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func loadCells() {
        
        containers = []
        
        Firestore.firestore().collection(Auth.auth().currentUser?.email ?? "ERROR" + K.Firestore.homeDirectory).order(by:K.Container.name).addSnapshotListener { (querySnapshot, error) in
            
            if let err = error {
                print(err)
            } else {
                if let docs = querySnapshot?.documents {
                    for doc in docs {
                        let data = doc.data()
                        if let contains = data[K.Folder.contains] {
                            self.containers.append(Folder(name: data[K.Folder.name] as! String, contains: contains as! [Container]))
                        } else if let content = data[K.File.content] {
                            self.containers.append(File(name: data[K.File.name] as! String, content: content as! String))
                        }
                    }
                    
                    //might need to be in loop
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}
