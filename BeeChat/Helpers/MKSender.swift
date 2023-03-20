//
//  MKSender.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-19.
//

import Foundation
import UIKit
import MessageKit

struct MKSender:SenderType,Equatable{
    var senderId: String
    var displayName: String
}

enum MessageDefaults{
    static let bubblecolorOutgoing = UIColor(named: "chatoutgoingcolor") ?? UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    static let bubblecolorIncoming = UIColor(named: "chatincomeingcolor") ?? UIColor(red: 230/255, green: 229/255, blue: 234/255, alpha: 1.0)

}
