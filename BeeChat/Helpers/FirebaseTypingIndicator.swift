
import Foundation
import FirebaseFirestore

class FirebaseTypingListener{
    static let shared = FirebaseTypingListener()
    var typyingListener: ListenerRegistration!
    init(){}
    
    func createTypingObserver(chatRoomId:String,completion:@escaping(_ isTyping:Bool)->Void)
    {
        typyingListener =  Firestore.firestore().collection(CollectionFire.Typing.rawValue).document(chatRoomId).addSnapshotListener({ snap, error in
            guard let snapshot = snap else {return}
            
            if snapshot.exists{
                for data in snapshot.data()!
                {
                    if data.key != User.currentId{
                        completion(data.value as! Bool)
                    }
                }
            }else{
                completion(false)
                Firestore.firestore().collection(CollectionFire.Typing.rawValue).document(chatRoomId).setData([User.currentId:false])
            }
        })
    }
    
    class func saveTypingCounter(typing:Bool,chatRoomId:String)
    {
        Firestore.firestore().collection(CollectionFire.Typing.rawValue).document(chatRoomId).updateData([User.currentId:typing])

    }
    
    func removeTypingListener(){
        self.typyingListener.remove()
    }
}
