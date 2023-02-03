//
//  FirebaseUser.swift
//  BeeChat
//
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseUser{
    
     static let shared = FirebaseUser()
    
     
    func registerUser(email:String,password:String,name:String,status:String = "Hi, there i am on BeeChat", completion:@escaping (_ error:Error?)->Void){
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            guard error == nil else{
                completion(error!)
                return
            }
            
            if let user = result?.user {
                
                let myuser = User(id:user.uid,username: name,email: user.email!,pushNotifyIdentifier: "",profileImg: "",status: status)
                
                
                self.saveUserOnFirebase(user:myuser)
                saveUserLocally(user:myuser)
                print(myuser)
                completion(nil)
            }
            
            
            
            
            
        }
    }
    
    func saveUserOnFirebase(user:User)
    {
        do{
           try Firestore.firestore().collection(CollectionFire.Users.rawValue).document(user.id).setData(from: user)
        }catch{
            
        }
       
    }
    
}


func saveUserLocally(user:User)
{
    let encode = JSONEncoder()
    do{
        let data = try encode.encode(user)
        UserDefaults.standard.set(data, forKey: ConstCurrentUser)

    }catch{
        
    }
}
