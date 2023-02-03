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
    var status = ""
    
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
                   
               }
           }else{
               return nil
           }
            
        }
        return nil
        
        
    }
    
}
