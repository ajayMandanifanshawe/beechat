//
//  User.swift
//  BeeChat
//
//

import Foundation
import FirebaseAuth

struct User:Codable,Equatable{
    var id = ""
    var username = ""
    var email = ""
    var pushNotifyIdentifier = ""
    var profileImg = ""
    var status = "Hi there, I am using BeeChat"
    var phoneNumber = "not specified"
    var statusMarriage = "not specified"
    var statusOccupation = "not specified"
    static var currentId:String{
        return Auth.auth().currentUser!.uid
    }
    
    
    static var currentUser:User?{
        
        if Auth.auth().currentUser != nil{
           
           if let currUser = UserDefaults.standard.data(forKey: ConstCurrentUser)
            {
               let decoder = JSONDecoder()
               do{
                   return try decoder.decode(User.self, from: currUser)
               }catch{
                   print(error.localizedDescription)
               }
           }else{
               return nil
           }
            
        }
        return nil
        
        
    }
    
}
