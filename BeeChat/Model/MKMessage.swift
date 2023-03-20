//
//  MKMessage.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-19.
//

import Foundation
import MessageKit
import CoreLocation

class MKMessage:NSObject,MessageType{

    var messageId: String
    var kind: MessageKind
    var sentDate: Date
    var incoming:Bool
    var mkSender:MKSender
    var sender: SenderType {return mkSender}
    var senderInitials:String
    var status:String
    var readDate:Date

    init(message:LocalMessage) {
        self.messageId = message.id
        self.kind = MessageKind.text(message.message)

        self.sentDate = message.date
        self.mkSender = MKSender(senderId: message.senderId, displayName: message.senderName)
        self.senderInitials = message.senderInitials
        self.status = message.status
        self.readDate = message.readDate
        self.incoming = User.currentId != mkSender.senderId

    }

}
