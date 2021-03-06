//
//  NewMessageControllerTableViewController.swift
//  GameOfChats
//
//  Created by Rahul Ranjan on 5/5/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class NewMessageTableViewController: UITableViewController {
    
    let cellId = "newMessageCell"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        FIRDatabase.database().reference().child("users").observe(.childAdded, with: { snapshot in
            
            if let userDicitionary = snapshot.value as? [String: Any] {
                let user = User()
                user.id = snapshot.key
                // This setter will crash if class properties doesn't match with
                // FIREBASE keys
                user.setValuesForKeys(userDicitionary)
                self.users.append(user)
                
                // Reload data should be on main thread
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        
        }, withCancel: nil)
        
    }
    
    func handleCancel() {
        self.dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        This is inefficient as it creates new cell
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        if let profileImageURL = user.profileImageUrl {
            
            cell.profileImageView.loadImageUsingCacheWithURLString(urlString: profileImageURL)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerWithUser(user: user)
        }
    }
}

