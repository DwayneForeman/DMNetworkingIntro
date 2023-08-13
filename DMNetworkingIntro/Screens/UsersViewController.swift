//
//  UsersViewController.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//

import UIKit

/**
 1. Create the user interface. See the provided screenshot for how the UI should look.
 2. Follow the instructions in the `User` file.
 3. Follow the instructions in the `NetworkManager` file.
 */
class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NetworkManagerDelegate {
    
    func usersRetrieved(_ userArray: [User]) {
        users = userArray
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.userReuseID, for: indexPath)
        // Grabbing the index of ONE single user
        let user = users[indexPath.row]
        // Tapping into the textLabel.numberOfLines poperty so this ONE single user has 2 lines with their cell
         cell.textLabel?.numberOfLines = 2
        // Tapping into the index ONCE to attach the firstName property - giving it a line break \n - then tapping into the current index ONCE AGAIN to add the email property. Wrapped by quites so we could add the line break via string interpolation
         cell.textLabel?.text = "\(user.firstName)\n\(user.email)"
        return cell
    }
    
    
    
    /**
     4. Create a variable called `users` and set it to an empty array of `User` objects.
     */
    
    var users = [User]()
    
    /**
     5. Connect the UITableView to the code. Create a function called `configureTableView` that configures the table view. You may find the `Constants` file helpful. Make sure to call the function in the appropriate spot.
     */
    @IBOutlet weak var usersTableView: UITableView!
    
    func configureTableView() {
        usersTableView.delegate = self
        usersTableView.dataSource = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUsers()
        configureTableView()
        
    }
    
    
    /**
     6.1 Set the `NetworkManager`'s delegate property to the `UsersViewController`. Have the `UsersViewController` conform to the `NetworkManagerDelegate` protocol. Call the `NetworkManager`'s `getUsers` function. In the `usersRetrieved` function, assign the `users` property to the array we got back from the API and call `reloadData` on the table view.
     */
    
    
    
    func getUsers() {
        
        NetworkManager.shared.delegate = self
        NetworkManager.shared.getUsers()
    
    }
}
