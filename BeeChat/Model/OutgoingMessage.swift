//
//  OutgoingMessage.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-20.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift

class OutgoingMessage{
    class func send(chatid:String, text:String?,photo:UIImage?,video:String?,audio:String?,location:String?,audioDuration:Float = 0.0,memberids:[String])
    {
        let currentUser = User.currentUser!
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatid
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = "sent"
        
        if text != nil{
            sendTextMessage(message: message, text: text!, memberId: memberids)
        }
        
        FirebaseLatestListener.shared.updateRevents(chatRoomId: chatid, lastMessafe: message.message)
        
    }
    
    class func sendMessage(message:LocalMessage,memberids:[String]){
        RealmManager.shared.saveToRealm(obj: message)
        for memberId in memberids{
            
            FirebaseMessageListner.shared.addMessage(message: message, memberId: memberId)
        }
    }
    
}

func sendTextMessage(message:LocalMessage,text:String,memberId:[String]){
    message.message = text
    message.type = "text"
    OutgoingMessage.sendMessage(message: message, memberids: memberId)
    
}



