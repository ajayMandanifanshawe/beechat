//
//  MessageViewController.swift
//  BeeChat
//
//  Created by Ajay Mandani on 2023-03-19.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Gallery
import RealmSwift


class MessageViewController: MessagesViewController {
    var chatId = ""
    var recepientId = ""
    var recepientName = ""
    var typingCounter = 0
    let leftbarButtonView:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        return view
    }()
    let subTitleLabel:UILabel = {
       let subtitle = UILabel(frame: CGRect(x: 5, y: 22, width: 180, height: 20))
        subtitle.textAlignment = .left
        subtitle.font = UIFont.systemFont(ofSize: 13,weight: .medium)
        subtitle.adjustsFontSizeToFitWidth = true
        return subtitle
    }()
    
    let titleLabel:UILabel = {
       let title = UILabel(frame: CGRect(x: 5, y: 0, width: 180, height: 25))
        title.textAlignment = .left
        title.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        title.adjustsFontSizeToFitWidth = true
        return title
    }()
    
    
    let refreshcontroller = UIRefreshControl()
    let micBtn = InputBarButtonItem()
    var notificationToken:NotificationToken?
    let currentUser = MKSender(senderId: User.currentId, displayName: User.currentUser!.username)
    
    var mkMessages:[MKMessage] = []
    var allLocalMessages: Results<LocalMessage>!
    let realm = try! Realm()
    
    init(chatId: String = "", recepientId: String = "", recepientName: String = "") {
        super.init(nibName: nil, bundle: nil)
        self.chatId = chatId
        self.recepientId = recepientId
        self.recepientName = recepientName
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configcollectionview()
        configmessageinputbar()
        loadChats()
        listenForNewChats()
//        self.title = recepientName
//        navigationItem.largeTitleDisplayMode = .never
        configLeftBarButton()
        configcustomTitle()
        listenforreadstatuschnage()
        
        createTypingObserver()
       
    }
    
    func listenforreadstatuschnage(){
        FirebaseMessageListner.shared.listenForReadStatusChnage(User.currentId, collectionId: chatId) { updatemessage in
            
            if updatemessage.status == "Read"{
                self.updatemessages(updatemessage)
            }
            
        }
    }
    
    func updatemessages(_ updatemessage:LocalMessage){
        for index in 0 ..< mkMessages.count{
            let tempmessage = mkMessages[index]
            if updatemessage.id == tempmessage.messageId{
                mkMessages[index].status = updatemessage.status
                mkMessages[index].readDate = updatemessage.readDate
                RealmManager.shared.saveToRealm(obj: updatemessage)
                if mkMessages[index].status == "Read"{
                    self.messagesCollectionView.reloadData()
                }
                    
            }
            
        }
    }

    func updateTypingIndicator(_ show:Bool){
        subTitleLabel.text = show ? "Typing... " : ""
    }
    
    
    func checkforoldchats(){
        FirebaseMessageListner.shared.checkforoldchats(documentid: User.currentId, collectionId: chatId)
    }
    
    
    func configcollectionview()
    {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messageCellDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messagesLayoutDelegate = self
        
        scrollsToLastItemOnKeyboardBeginsEditing = true
        maintainPositionOnInputBarHeightChanged = false
        messagesCollectionView.refreshControl = refreshcontroller
    }
    
    
    func configmessageinputbar()
    {
        messageInputBar.delegate = self
        let attachBtn = InputBarButtonItem()
        attachBtn.image = UIImage(systemName: "plus",withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        attachBtn.setSize(CGSize(width: 30, height: 30), animated: false)
        attachBtn.onTouchUpInside { item in
            print("bbtn pressed")
            
        }
     
        micBtn.image = UIImage(systemName: "mic")
        micBtn.setSize(CGSize(width: 30, height: 30), animated: false)
//        micBtn.onTouchUpInside { item in
//            print("bbtn pressed")
//
//        }
        messageInputBar.setStackViewItems([attachBtn], forStack: .left, animated: false)
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        
//        updateMicButtonStatus(show:true)
        
        messageInputBar.inputTextView.isImagePasteEnabled = false
        messageInputBar.backgroundView.backgroundColor = .systemBackground
        messageInputBar.inputTextView.backgroundColor = .systemBackground
    }
    
    
    func updateMicButtonStatus(show:Bool)
    {
        if show{
            messageInputBar.setStackViewItems([micBtn], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 30, animated: false)
        }else{
            messageInputBar.setStackViewItems([messageInputBar.sendButton], forStack: .right, animated: false)
            messageInputBar.setRightStackViewWidthConstant(to: 55, animated: false)
        }
    }
    
    
    func messageSend(text:String?,photo:UIImage?,video:String?,audio:String?,location:String?,audioDuration:Float = 0.0)
    {
        OutgoingMessage.send(chatid: chatId, text: text, photo: photo, video: video, audio: audio, location: location, memberids: [User.currentId,recepientId])
    }
    

    
    func loadChats(){
        let predicate = NSPredicate(format: "chatRoomId = %@", chatId)
    
        allLocalMessages = realm.objects(LocalMessage.self).filter(predicate).sorted(byKeyPath: "date",ascending: true)

        
        if allLocalMessages.isEmpty{
            checkforoldchats()
        }

        notificationToken = allLocalMessages.observe({ (changes:RealmCollectionChange) in
            switch changes {
            case .initial:
                print("dd")
                self.inseertMessages()
                self.messagesCollectionView.reloadData()
                self.messagesCollectionView.scrollToLastItem(animated: true)
            case .update(_,_, let insertions ,_ ):
                for index in insertions{
                    self.insertMessage(localMessage: self.allLocalMessages[index])
                    self.messagesCollectionView.reloadData()
                    self.messagesCollectionView.scrollToLastItem(animated: false)

                }
            case .error(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    
    func inseertMessages(){
        for message in allLocalMessages {
            insertMessage(localMessage: message)
        }
    }
    
    func insertMessage(localMessage:LocalMessage){
        
        if localMessage.senderId != User.currentId{
            markasreadmessage(localMessage: localMessage)
        }
       
        let incoming = IncomingMessage(messageCollectionView: self)
        self.mkMessages.append(incoming.createMessage(localMessage: localMessage))
       
    }
    
    func markasreadmessage(localMessage:LocalMessage)
    {
        if localMessage.senderId != User.currentId && localMessage.status != "Read"{
            FirebaseMessageListner.shared.updateMessageInFirebase(localMessage, memeberIds: [User.currentId,recepientId])
        }
        
    }
    
    
    func configLeftBarButton(){
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backbtnPress))]
    }
    
    func configcustomTitle(){
        leftbarButtonView.addSubview(titleLabel)
        leftbarButtonView.addSubview(subTitleLabel)
        let leftbarButtonItem = UIBarButtonItem(customView: leftbarButtonView)
        self.navigationItem.leftBarButtonItems?.append(leftbarButtonItem)
        titleLabel.text = recepientName
        
    }
    
    @objc func backbtnPress(){
        FirebaseLatestListener.shared.resetRecentCounter(chatRoomId: chatId)
        removeListener()
        self.navigationController?.popToRootViewController(animated: true)
    }
    func lastMessageDate()->Date{
        let lastmess = allLocalMessages.last?.date ?? Date()
        return Calendar.current.date(byAdding: .second,value: 1, to: lastmess) ?? lastmess
    }
    
    
    func listenForNewChats(){
        FirebaseMessageListner.shared.listenForNewChats(documentId: User.currentId, collectionid: chatId, lastMessageDate: lastMessageDate())
    }
    func removeListener(){
        FirebaseTypingListener.shared.removeTypingListener()
        FirebaseMessageListner.shared.removeListener()
    }
    func createTypingObserver(){
        FirebaseTypingListener.shared.createTypingObserver(chatRoomId: chatId) { isTyping in
            DispatchQueue.main.async {
                self.updateTypingIndicator(isTyping)
            }
        }
    }
    
    func typingIndecatorUpdate(){
        typingCounter += 1
        FirebaseTypingListener.saveTypingCounter(typing: true, chatRoomId: chatId)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
            self.typingCounterStop()
        }
    }
    
    func typingCounterStop(){
        typingCounter -= 1
        if typingCounter == 0{
            FirebaseTypingListener.saveTypingCounter(typing: false, chatRoomId: chatId)
        }
    }
    

}
