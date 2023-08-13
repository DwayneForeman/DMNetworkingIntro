//
//  User.swift
//  DMNetworkingIntro
//
//  Created by David Ruvinskiy on 4/10/23.
//

import Foundation

/**
 2.1 For this project, we will be working with **only the "/users" endpoint**. The JSON you get back from this endpoint will contain many keys, but we care about only the "data" key. The value for this key is an array of several JSON objects representing fake users.
 
 Familiarize yourself with the documentation for the endpoint: https://reqres.in/api-docs/#/default/get_users. Do not move on until you until you're comfortable with the data you'll get back.
 
 2.2 Based on the JSON, create a struct called `User` that conforms to the `Codable` protocol and contains the following properties:
    - An Int `id`
    - A String `email`
    - A String `firstName`
    - A String `lastName`
    - a String `avatar`
 
 
 
 
 
 2.3 Create a separate structure called `UserResponse` that also conforms to `Codable` and contains a single `[User]` called data.
 */

// User data model can encode and decode from external JSON representation
// Based on the JSON struct of the API we wil setup our User Modal as follows:

/*
 
 JSON schema
 
 {
   "data": {
     "id": 0,
     "email": "string",
     "first_name": "string",
     "last_name": "string",
     "avatar": "string"
   }
 }
 
 Structure schema
 
 User{
 id    integer
 email    string
 first_name    string
 last_name    string
 avatar    string
 }
 
 */


// So what's happening here?
// First, we needed to create a sturcture model of user that confirms to Codebale to endcode and decode. This structuure gives use the data model we need to them pass inyo the structure below which Users will be held as array wequal to data
struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
}

struct UserResponse: Codable {
    
    var data = [User]()
    
}
