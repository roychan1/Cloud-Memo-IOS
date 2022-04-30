//
//  DirectoryViewController.swift
//  CloudMemo
//
//  Created by roy on 3/30/22.
//

import UIKit
import Firebase
import SWTableViewCell

class DirectoryViewController: UITableViewController {
    
    @IBOutlet weak var signOutButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    //array of folders and/or files
    var containers : [Container] = []
    var currentCollection : CollectionReference!
    var selectedIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print("Current Collection:     " + currentCollection.path)
        
        tableView.dataSource = self
        
        setHomeFolder()
        setUpAddMenu()
        loadCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavBar()
    }
    
    
    func setHomeFolder() {
        setUpNavBar()
        
        backButton.image = UIImage(systemName: "chevron.backward")
        backButton.tintColor = UIColor.white
        
        tableView.register(UINib(nibName: K.nibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        tableView.rowHeight = 60
    }
    
    func setUpNavBar() {
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        if currentCollection == Firestore.firestore().collection(K.Firestore.homeFoldersPointer).document(K.Firestore.homeFolders).collection(Auth.auth().currentUser!.uid) {
            
            navigationItem.title = "Home"
            navigationItem.leftBarButtonItems = [signOutButton]
        } else {
            
            navigationItem.title = currentCollection.collectionID
            navigationItem.leftBarButtonItems = [signOutButton, backButton]
        }
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.configureWithOpaqueBackground()
        barAppearance.backgroundColor = UIColor(red: CGFloat(178/255.0), green: CGFloat(154/255.0), blue: CGFloat(118/255.0), alpha: CGFloat(1.0))
        barAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        barAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
//          NSAttributedString.Key.font: UIFont.systemFont(ofSize: 23, weight: UIFont.Weight.regular)

        navigationItem.standardAppearance = barAppearance
        navigationItem.scrollEdgeAppearance = navigationItem.standardAppearance
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
        let alert = UIAlertController(title: "Enter file name", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Create", style: .default) {_ in
            
            if alert.textFields?[0].text != "" {
                let newFile = self.currentCollection.document(alert.textFields![0].text!)
                newFile.setData([K.Firestore.type: K.Firestore.fileType, K.Container.created: Date(), K.Container.File.content: ""])
                //segue
            } else {
                let noEmptyNameAlert = UIAlertController(title: "File name cannot be empty.", message: "", preferredStyle: .alert)
                noEmptyNameAlert.addAction(UIAlertAction(title: "Ok", style: .default) {_ in
                    noEmptyNameAlert.dismiss(animated: true, completion: nil)
                })
                
                self.present(noEmptyNameAlert, animated: true, completion: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {_ in
            alert.dismiss(animated: true, completion: nil)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func makeNewFolder() {
        let alert = UIAlertController(title: "Enter folder name", message: "", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Create", style: .default) {_ in

            if alert.textFields?[0].text != "" {
//                    Firestore.firestore().collection(K.Firestore.homeFoldersPointer).document(K.Firestore.homeFolders).collection(id)
                let newFolder = self.currentCollection.document(alert.textFields![0].text!)
                newFolder.setData([K.Firestore.type: K.Firestore.folderType, K.Container.created: Date()])
                newFolder.collection(alert.textFields![0].text!)
            } else {
                let noEmptyNameAlert = UIAlertController(title: "Folder name cannot be empty.", message: "", preferredStyle: .alert)
                noEmptyNameAlert.addAction(UIAlertAction(title: "Ok", style: .default) {_ in
                    noEmptyNameAlert.dismiss(animated: true, completion: nil)
                })

                self.present(noEmptyNameAlert, animated: true, completion: nil)
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .default) {_ in
            alert.dismiss(animated: true, completion: nil)
        })

        self.present(alert, animated: true, completion: nil)
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
        //use currentCollection variable

        currentCollection.order(by: K.Container.created).addSnapshotListener { [self] (querySnapshot, error) in
        
            if let err = error {
                print(err)
            } else {
                self.containers = []
                if let docs = querySnapshot?.documents {
                    for doc in docs {
                        let data = doc.data()
                        if let type = data[K.Container.type] as? String {
                            if type == K.Firestore.emptyType {
                                continue
                            } else if type == K.Firestore.folderType {
                                if let timestamp = data[K.Container.created] as? Timestamp {
                                    self.containers.append(Folder(name: doc.documentID, type: K.Firestore.folderType, created: timestamp.dateValue(), contains: data[K.Container.Folder.contains] as? [Container] ?? []))
                                }
                            } else if type == K.Firestore.fileType {
                                if let timestamp = data[K.Container.created] as? Timestamp {
                                    self.containers.append(File(name: doc.documentID, type: K.Firestore.fileType, created: timestamp.dateValue(), content: data[K.Container.File.content] as! String))
                                }
                            }
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
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return containers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! ContainerCell
        
        cell.bracketImage.isHidden = false
        if containers[indexPath[1]].type == K.Firestore.fileType {
            cell.bracketImage.isHidden = true
        }
        
        cell.titleLabel.text = containers[indexPath.row].name
        
        let deleteButton = UIButton()
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.regular)
        deleteButton.setTitleColor(UIColor.white, for: .normal)
        deleteButton.backgroundColor = UIColor.red
        cell.tag = indexPath[1]
        cell.rightUtilityButtons = [deleteButton]
        cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (containers[indexPath[1]].type == K.Firestore.folderType) {
            if let storyboard = self.storyboard?.instantiateViewController(withIdentifier: K.directoryViewIdentifier) as? DirectoryViewController {
                storyboard.currentCollection = currentCollection.document(containers[indexPath[1]].name).collection(containers[indexPath[1]].name)
                self.navigationController?.pushViewController(storyboard, animated: true)
            }
        } else if (containers[indexPath[1]].type == K.Firestore.fileType) {
            navigationItem.title = ""
            selectedIndex = indexPath[1]
            self.performSegue(withIdentifier: K.Segue.openDocument, sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segue.openDocument {
            if let dest = segue.destination as? FileViewController {
                dest.currentCollection = currentCollection
                dest.name = containers[selectedIndex].name
            }
        }
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension DirectoryViewController: SWTableViewCellDelegate {
    
    func swipeableTableViewCell(_ cell: SWTableViewCell!, didTriggerRightUtilityButtonWith index: Int) {
        currentCollection.document(containers[cell.tag].name).delete() { err in
            if let e = err {
                print(e)
            }
        }
    }
}
