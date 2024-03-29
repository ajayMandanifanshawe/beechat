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
    
    func saveImageOnRecent(imageurl:String)
    {
        Firestore.firestore().collection(CollectionFire.Recent.rawValue).whereField("receiverId",isEqualTo: User.currentId) .getDocuments { querysnap , error in
            guard let snapshot = querysnap else{
                return
            }
            
          
            let allres = snapshot.documents.compactMap { query -> RecentChat? in
                do{
                    return try query.data(as: RecentChat.self)
                }catch{
                    print("error found")
                    print(error.localizedDescription)
                }
               return nil
                
            }
            
            
            
            let val = ["avatarLink":imageurl] as [String:Any]
//            for userId in memeberIds{
//                Firestore.firestore().collection(CollectionFire.Message.rawValue).document(userId).collection(message.chatRoomId).document(message.id).updateData(val)
//            }
            
            for res in allres{
                Firestore.firestore().collection(CollectionFire.Recent.rawValue).document(res.id)
                    .updateData(val)
                
                
            }

           
        }
       
    }
    
    func getAllUser(completion: @escaping (_ alluser:[User])->Void){
        
        var getuser:[User] = []
        
        Firestore.firestore().collection(CollectionFire.Users.rawValue).getDocuments { query, error in
            
            guard let query = query else {
                return
            }
            
            let tempuser = query.documents.compactMap { userall -> User in
               try! userall.data(as: User.self)
            }
            
            for user in tempuser{
                if (user.id != User.currentId)
                {
                    getuser.append(user)
                }
            }
            
            completion(getuser)
            
        }
        
    }
    
    func downloadUserFromFirebase(withId:[String],completion: @escaping(_ allUsers:[User]?)->Void )
    {
        var count = 0
        var userArray:[User] = []
        for userid in withId{
            Firestore.firestore().collection(CollectionFire.Users.rawValue).document(userid).getDocument { SnapshotDat, error in
                
                if error != nil{
                    completion(nil)
                    print(error?.localizedDescription ?? "")
                    return
                }
                
                let user = try? SnapshotDat?.data(as: User.self)
                userArray.append(user!)
                count+=1
                
                if(count == withId.count)
                {
                    completion(userArray)
                }
                
            }
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


