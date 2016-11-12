//
//  ContactsViewController.swift
//  DeviceFrameworksDemo
//
//  Created by Harley Trung on 4/11/16.
//  Copyright © 2016 coderschool.vn. All rights reserved.
//

import UIKit
import Contacts
import ContactsUI

class ContactsViewController: UIViewController {
    var store: CNContactStore!
    var objects = [CNContact]()
    
    @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
        print("add existing contact")
        addExistingContact()
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        getContacts()
    }
    
    func getContacts() {
        store = CNContactStore()
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if status == .notDetermined {
            showMessage("Give me your contacts?", okHandler: { 
                self.requestForAccess({ (accessGranted) in
                    if accessGranted {
                        self.retrieveContactsWithStore(self.store)
                    }
                })
                }, cancelHandler: {
                    self.showMessage("No problem. I'll ask again", okHandler: nil, cancelHandler: nil)
            })
            
        } else if status == .authorized {
            self.retrieveContactsWithStore(store)
        } else {
            showMessage("Uh oh. No permission: \(status.rawValue)", okHandler: nil, cancelHandler: nil)
        }
    }
    
    func retrieveContactsWithStore(_ store: CNContactStore) {
        do {
            let groups = try store.groups(matching: nil)
            let predicate = CNContact.predicateForContactsInGroup(withIdentifier: groups[0].identifier)
            //let predicate = CNContact.predicateForContactsMatchingName("John")
            let keysToFetch = [CNContactFormatter.descriptorForRequiredKeys(for: .fullName), CNContactEmailAddressesKey] as [Any]
            
            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
            self.objects = contacts
            DispatchQueue.main.async(execute: { () -> Void in
                self.tableView.reloadData()
            })
        } catch {
            print(error)
        }
    }
    
    func requestForAccess(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.store.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        DispatchQueue.main.async(execute: { () -> Void in
                            let message = "\(accessError!.localizedDescription)\n\nPlease allow the app to access your contacts through the Settings."
                            self.showMessage(message, okHandler: nil, cancelHandler: nil)
                        })
                    }
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func showMessage(_ message: String, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alertController = UIAlertController(title: "About your contacts", message: message, preferredStyle: .alert)
        
        if let handler = cancelHandler {
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
                handler()
            }
            alertController.addAction(cancelAction)
        }
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            okHandler?()
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
    }
}

extension ContactsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        
        let contact = self.objects[(indexPath as NSIndexPath).row]
        let formatter = CNContactFormatter()
        
        cell.nameLabel.text = formatter.string(from: contact)
        //        cell.emailLabel.text = contact.emailAddresses.first?.value as? String
        
        return cell
    }
}

extension ContactsViewController: CNContactPickerDelegate {
    func addExistingContact() {
        
        
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        present(contactPicker, animated: true, completion: nil)
    }
    
    //    func contactPicker(picker: CNContactPickerViewController, didSelectContact contact: CNContact) {
    //        objects.append(contact)
    //        //dispatch_async(dispatch_get_main_queue(), { () -> Void in
    //        self.tableView.reloadData()
    //        //})
    //        //        NSNotificationCenter.defaultCenter().postNotificationName("addNewContact", object: nil, userInfo: ["contactToAdd": contact])
    //    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        objects = objects + contacts
        print("selected multiple contacts", contacts)
    }
}
