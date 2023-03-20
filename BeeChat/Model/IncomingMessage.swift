//
//  IncomingMessage.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-20.
//

import Foundation
import MessageKit
import CoreLocation


class IncomingMessage{
    
    var messageCollectionView:MessagesViewController
    init(messageCollectionView: MessagesViewController) {
        self.messageCollectionView = messageCollectionView
    }
    
    func createMessage(localMessage:LocalMessage) -> MKMessage{
        let mkmessage = MKMessage(message: localMessage)
        
        return mkmessage
    }
    
    
    
}
