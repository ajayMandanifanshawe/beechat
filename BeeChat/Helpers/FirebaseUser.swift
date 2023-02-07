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
                
                let myuser = User(id:user.uid,username: name,email: user.email!,pushNotifyIdentifier: "",profileImg: "",status: status,phoneNumber: "no phone number specified")
                
                
                self.saveUserOnFirebase(user:myuser)
//                saveUserLocally(user:myuser)
                print(myuser)
                completion(nil)
            }
            
            
            
            
            
        }
    }
    
    func signin(email:String,password:String, completion:@escaping (_ error:Error?)->Void){
        Auth.auth().signIn(withEmail: email, password: password) { res, error in
            guard error == nil else{
                completion(error!)
                return
            }
            
            
            self.downloadUserFromFirebase(userId: (res?.user.uid)!)
            completion(nil)
            
        }
    }
    
    func downloadUserFromFirebase(userId:String,email:String?=""){
        Firestore.firestore().collection(CollectionFire.Users.rawValue).document(userId).getDocument { snap, error in
            if error == nil{
                
                do{
                    let user = try snap?.data(as: User.self)
                    if let user = user{
                        saveUserLocally(user: user)
                    }
                }catch{
                    
                }
                

               
                
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
