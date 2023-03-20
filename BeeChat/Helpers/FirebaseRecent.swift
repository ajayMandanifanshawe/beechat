//
//  FirebaseRecent.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-14.
//

import Foundation

import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift


class FirebaseLatestListener{
    static let shared = FirebaseLatestListener()
    private init(){}
    
    func addLatest(latest:RecentChat)
    {
        do{
            try Firestore.firestore().collection(CollectionFire.Recent.rawValue).document(latest.id).setData(from: latest)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    func downloadAllLatestfromfirestore(completion:@escaping(_ latest:[RecentChat]?)->Void)
    {
        Firestore.firestore().collection(CollectionFire.Recent.rawValue).whereField("senderId", isEqualTo: User.currentId).addSnapshotListener { snap, error in
            
            if error != nil{
                completion(nil)
                return
            }
            
            if snap!.documents.isEmpty{
                completion(nil)
                return
            }
            
            var latestfire:[RecentChat] = []
            let allres = snap!.documents.compactMap { query -> RecentChat? in
                do{
                    return try query.data(as: RecentChat.self)
                }catch{
                    print("error found")
                    print(error.localizedDescription)
                }
               return nil
                
            }
            
            for res in allres{
                if res.lastMessage != ""{
                    latestfire.append(res)
                }
            }
            
            latestfire = latestfire.sorted(by: {$0.date! > $1.date!})
            
            completion(latestfire)
            
            }
    }
    
    func deleteLatets(latest:RecentChat)
    {
        Firestore.firestore().collection(CollectionFire.Recent.rawValue).document(latest.id).delete()
    }
    
    
    
    func resetRecentCounter(chatRoomId:String)
    {
        Firestore.firestore().collection(CollectionFire.Recent.rawValue).whereField("chatRoomId", isEqualTo: chatRoomId).whereField("senderId", isEqualTo: User.currentId).getDocuments { snap, err in
            
            guard let doc = snap?.documents else{
                print("no doc found for recent on line 71 recent")
                return
            }
            
            let allRec = doc.compactMap { query -> RecentChat? in
                return try? query.data(as: RecentChat.self)
            }
            
            if allRec.count > 0{
                self.clearunreadCounter(recent: allRec.first!)
            }
            
            
        }
    }
    
    func clearunreadCounter(recent:RecentChat)
    {
        var rec = recent
        rec.unreadCounter = 0
        self.addLatest(latest: rec)
    }
    
    
    
    func updateRevents(chatRoomId:String,lastMessafe:String)
    {
        Firestore.firestore().collection(CollectionFire.Recent.rawValue).whereField("chatRoomId", isEqualTo: chatRoomId).getDocuments { snap, err in
            guard let doc = snap?.documents else{
                print("no doc")
                return
            }
            let allrecent = doc.compactMap { query -> RecentChat in
                return try!  query.data(as: RecentChat.self)
            }
            
            for rec in allrecent{
                self.updateRecenetItemWithNewMessage(recent: rec, lastMessage: lastMessafe)
            }
            
        }
    }
    
    func updateRecenetItemWithNewMessage(recent:RecentChat,lastMessage:String)
    {
        var Temprecent = recent
        if Temprecent.senderId != User.currentId{
            Temprecent.unreadCounter += 1
            
        }
        Temprecent.lastMessage = lastMessage
        Temprecent.date = Date()
        
        self.addLatest(latest: Temprecent)
    }
    
}


func startchat(user1:User,user2:User) -> String
{
    let chatroomid = chatroomIdFrom(user1Id: user1.id, user2Id: user2.id)
    
    createLatestItems(chatroomid: chatroomid, users: [user1,user2])
    return chatroomid
}

func chatroomIdFrom(user1Id:String,user2Id:String)->String{
    var chatroomid = ""
    
    let val = user1Id.compare(user2Id).rawValue
    
    chatroomid = val < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    
    return chatroomid
}

func createLatestItems(chatroomid:String,users:[User])
{
    var membersIdToCreateRecent = [users.first!.id,users.last!.id]
    var getrec = [users.first!,users.last!]
    let index = getrec.firstIndex(of: User.currentUser!)
    getrec.remove(at: index!)
    let recidgen = getrec.first
    Firestore.firestore().collection(CollectionFire.Recent.rawValue).whereField("chatRoomId",isEqualTo: chatroomid).getDocuments { snapshot, error in
        
        guard let snapshot = snapshot else{
            return
        }
        if !snapshot.isEmpty{
            membersIdToCreateRecent = removememebr(snapshot: snapshot, memberIds: membersIdToCreateRecent)
        }
      
        for userid in membersIdToCreateRecent{
            
            let senderId = userid == User.currentId ? User.currentUser! : recidgen!
            let receiverId = userid == User.currentId ? recidgen! : User.currentUser!
           
           
            
            let recentobj = RecentChat(id: UUID().uuidString,chatRoomId: chatroomid,senderId: senderId.id,senderName: senderId.username,receiverId: receiverId.id,receiverName: receiverId.username,date: Date(),memeberIds: [senderId.id,receiverId.id],lastMessage: "",unreadCounter: 0,avatarLink: receiverId.profileImg)
            
        
            
            FirebaseLatestListener.shared.addLatest(latest: recentobj)
            
            

        }
        
        
    }
}

func removememebr(snapshot:QuerySnapshot,memberIds:[String]) -> [String]
{
    var memebridtocreate = memberIds
    
    for recentDara in snapshot.documents{
        let currentRecenet = recentDara.data() as Dictionary
        
        if let currentUserID = currentRecenet["senderId"]{
            if memebridtocreate.contains(currentUserID as! String){
                memebridtocreate.remove(at: memebridtocreate.firstIndex(of: currentUserID as! String)!)
            }
        }
       
    }
    
    return memebridtocreate
}

func restartChat(chartRoomId:String,memeberIds:[String])
{
    FirebaseUser.shared.downloadUserFromFirebase(withId: memeberIds) { allUsers in
        if allUsers!.count > 0{
            createLatestItems(chatroomid: chartRoomId, users: allUsers!)
        }
    }
}
