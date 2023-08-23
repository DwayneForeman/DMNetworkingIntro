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
        
        // 3.1 Modify the UsersViewController to use the completion closure instead of the NetworkManagerDelegate.
        // Since we will not be using the NetworkManagerDlegate per instructions, we will comment the code below out
        //NetworkManager.shared.delegate = self
        
        // Remeber, networkManager is our helper aka Manager. We are telling to fetch users (getUsers) and we're giving it an order to do something once thise users are fetch. Those orders/rules will appear in teh closure { }
        // result is the actual vales we get back from fetching
        NetworkManager.shared.getUsers { [weak self] result in
            // in, meaning - Now let's check to see what happens after we get our rsults, do we succeed or get an error
            // so let's hit the switch on result for BOTH a .success case and a .falure case as the switch must be exaustive
            // since we are using DMError, our reult from fetching users will be of type Erorrr which already contains .success() and .failure() methods
            switch result {
                
                // capture the list of users we got from this result success case by creating a let users constant
            case .success(let listOfUsers):
                // Now take the list of users we captured in listOfUsers form our success case and equal it to OUT var users variiable able
                self?.users = listOfUsers
                
                // Let's make sure after this success case it will happen on the main thread as this had to do with the UI of the app
                DispatchQueue.main.async {
                    self?.usersTableView.reloadData()
                }
                // If we encounter an erro whiel fetching reults lets capture it with let captureError
            case .failure(let captureError):
                // Let's present that error with the function we created below and pass in the captureError constant we created above
                self?.presentAlert(error: captureError)
                
                
            }
            
        }
        
    }
        // 3.2 Add a function called presentAlert to the UsersViewController that accepts a DMError and presents a UIAlertController with that error. Call presentError if there's a failure.
       // create the presentAlert function and give it a parameter that should be of type DMError
        func presentAlert(error: DMError) {
            // Make this present alert an actual UIAlertController so lets create a UIAlrtCOntroller object
            // title added, meesage should be the actual rawalue of the error we recived and the style should be that of .alert
            let presentAlertController = UIAlertController(title: "Whoop, there an error", message: error.rawValue, preferredStyle: .alert)
            
            // Let's get fancy and add an action to the alert so we can actually exit out of it
            // This is like our okay" button to close out of the alert prompt
            let thanksBatmanButton = UIAlertAction(title: "Thanks for catching that Batman", style: .default)
            
            // We created the alert and the alert acton button but now lets tie them together
            // We'll use teh builtuin in .addAction method of the UIAlertController class
            // pass in out thanksBatmanButton
            presentAlertController.addAction(thanksBatmanButton)
            
            // Great we've created it, now we have to present it
            present(presentAlertController, animated: true, completion: nil)
            
        }
        
    
    
}
