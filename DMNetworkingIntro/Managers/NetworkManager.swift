//
//  NetworkManager.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//

import Foundation

/**
 3.1 Create a protocol called `NetworkManagerDelegate` that contains a function called `usersRetrieved`.. This function should accept an array of `User` and should not return anything.
 */

// Remeber: A delegate is a protocol in which you must conform to
protocol NetworkManagerDelegate {
    
    func usersRetrieved(_ userArray: [User])
    
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseUrl = "https://reqres.in/api/"
    
    private init() {}
    
    /**
     3.2 Create a variable called `delegate` of type optional `NetworkManagerDelegate`. We will be using the delegate to pass the `Users` to the `UsersViewController` once they come back from the API.
     */
    
    var delegate: NetworkManagerDelegate?
    
    /**
     3.3 Makes a request to the API and decode the JSON that comes back into a `UserResponse` object.
     3.4 Call the `delegate`'s `usersRetrieved` function, passing the `data` array from the decoded `UserResponse`.
     
     This is a tricky function, so some starter code has been provided.
     */
    
    // 2.1 Modify the getUsers function to accept a completion closure. The closure should accept a Result For the success case, the associated value for the result should be an array of User. For the failure case, the associated value should be a DMError.
    // name teh completion handler "completion" :
    // Use @escpaing as the completion handler is async meaning it will run AFTER the getUsers function and not WHILE
    // In parenthees I added the adgument using the Result enmum that takes in < a_success, a_failure >
    // Closure does NOT return so we I used -> Void
    func getUsers(completion: @escaping (Result<[User], DMError>) -> Void) {
        
        // In this function we are
        /*
         
         1. create urlString
         2. Creating urlString to pass into URL object
         3. Chck if url is nil if so exit
         4. Create shared url session data tasks
            4A. Check if error is nil if so exit
            4B. Take data from completion handler and equal it to if let (optional binding) and if no data exit the finction via (else { return } )
            4C. Within that if let create your decoder object by setting your xonst equal to JSONDecoder
            4D. Tap into the .keyDeocdingStrgegory property of decoder and make it equal to .covertFromSnakeCase so we can take uppercase/lowerxase
            4E. "try" to decode the safeData into a UserResponse object if not, since it throw in error wrap in do/catch block and catch the error - catpture/equal the value to constant
            4F. tap into teh delegate var we created about and use the userRetieved function to passed in the userReponse constant we created in 4E. and tap into it's .data whch is of type [User]
            4G. Once you've set up your data task - dataTask(with:completionHandler:) - specified the URL, headers, etc. and defined what should happen when the task completes (in the completionHandler closure), you call task.resume() to start the task.
         
         */
        
        
            // 3.3 Append the "/users" endpoint to the base URL and store the result in a variable. You should end up with this String: "https://reqres.in/api/users".
           let urlString = baseUrl + "users"
            print(urlString)
            
            // 3.3 Create a `URL` object from the String. If the `URL` is nil, break out of the function.
            
            let url = URL(string: urlString)
            
            if url == nil {
                // 2.2 Continue to modify getUsers to use the closure. For all failures, call the completion closure with the correct DMError. For a success, call the completion closure with the array of User.
                // Using the completion handler if the function runs and there are is not a valid url per the description of the DM error enum
                //  Declare the function as you normally would and pass in the parameters ()
                // Within the parameters tap into the faulire method using dot notation and within the failure method pass in .invaludURL -  case invalidURL = "There was an issue connecting to the server."
                completion(.failure(.invalidURL))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url!) { data, response, error in
                // 3.3 If the error is not nil, break out of the function.
                if error != nil {
                    // 2.2 Continue to modify getUsers to use the closure. For all failures, call the completion closure with the correct DMError. For a success, call the completion closure with the array of User.
                    // Using the completion handler if the function runs and there are is not a valid URL SESSION REQUEST per the description of the DM error enum
                    //  Declare the function as you normally would and pass in the parameters ()
                    // Within the parameters tap into the faulire method using dot notation and within the failure method pass in .unableToComplete -  case unableToComplete = "Unable to complete your request. Please check your internet connection."
                    completion(.failure(.unableToComplete))
                    return
                }
                
                
                
                // 3.3 Unwrap the data. If it is nil, break out of the function.
                if let safeData = data {
                    print(String(data: safeData, encoding: .utf8)!) // Prin the JSON data
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    do {
                        // 3.3 Use the provided `decoder` to decode the data into a `UserResponse` object.
                        // Method Uderstanding: .decode(what object we want to turn the data into, from: where we are gettign the data FROM)
                        // WHAT EXALCTY IS HAPPENING BELOW?
                        // 1. We needed to decode the data (aka safedata) we get from the API INTO a UserResponse object. We then need to capture it with a let so we can pass in on the next line. Sine the decoder call can throw an error we mark it with try
                        
                        // EASY UNDERSTANDING FOR BELOW: We are usinf safeData amd turning it into a UserResponse object which has a data array propery of Users which we will tap into on the next line
                        let userResponse = try decoder.decode(UserResponse.self, from: safeData)
                        // 2. Now we are using the var delegate we created above which is of type NeworkManagerDelegate which we alsp created above whihc contains the usersrteieved function meaning, if you are hoing to be on tyoe NetworkManager Delegate you must have the usersReteived function. We created a var delegate of its type because we cannot tap into the actual protol its as it is a class and since we already know since it confirms to the NetworkManagerDelegate protocol that it would have the function we needed to use later down the line,, here.
                        // 3.4 Call the `delegate`'s `usersRetrieved` function, passing the `data` array from the decoded `UserResponse`.
                        self.delegate?.usersRetrieved(userResponse.data)
                        
                        // 2.2 Continue to modify getUsers to use the closure. For all failures, call the completion closure with the correct DMError. For a success, call the completion closure with the array of User.
                        // Using the completion handler if the function runs and there IS VALID !!!! DATA FROM THE SERVER per the description of the DM error enum
                        //  Declare the function as you normally would and pass in the parameters ()
                        // Within the parameters tap into the SUCCESS method using dot notation and within the SUCCESS method pass in THE SUCESSFUL DATA aka userResponse.data
                        completion(.success(userResponse.data))
                        
                        
                    } catch {
                        // 2.2 Continue to modify getUsers to use the closure. For all failures, call the completion closure with the correct DMError. For a success, call the completion closure with the array of User.
                        // Using the completion handler if the function runs and there are INVALID RESPONSE FROM THE SERVER (since as you see above we are handlign taks FOR A VALID RESPONSE from the server. per the description of the DM error enum
                        //  Declare the function as you normally would and pass in the parameters ()
                        // Within the parameters tap into the faulire method using dot notation and within the failure method pass in .invalidResponse -  case invalidResponse = "Invalid response from the server. Please try again."
                        print("Error recvecing a retriving a reponse \(error)")
                        completion(.failure(.invalidResponse))
                    }
                    
                } else {
                    // 2.2 Continue to modify getUsers to use the closure. For all failures, call the completion closure with the correct DMError. For a success, call the completion closure with the array of User.
                    // Using the completion handler if the function runs and there are INVALID DATA FROM THE SERVER (since as you see above we are handlign taks FOR VALID DATA here (if let safeData = data). per the description of the DM error enum
                    //  Declare the function as you normally would and pass in the parameters ()
                    // Within the parameters tap into the faulire method using dot notation and within the failure method pass in .invalidData -  case invalidData = "The data received from the server was invalid. Please try again."
                    completion(.failure(.invalidData))
                    return
                }
                
            }
            task.resume()
        }
}
