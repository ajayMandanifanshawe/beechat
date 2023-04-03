//
//  Storage.swift
//  BeeChat
//

import Foundation

import Foundation
import FirebaseStorage
import ProgressHUD
import UIKit
let storage = Storage.storage()

class Filestorage{
   class func uploadImage(_ image:UIImage,directory:String,completion:@escaping(_ documentLink:String?)->Void){
           
        let storeageRef = storage.reference(forURL: "gs://beechat-74a68.appspot.com").child(directory)
        
        let imgData = image.jpegData(compressionQuality: 0.6)
        
        var task:StorageUploadTask!
        task = storeageRef.putData(imgData!,metadata: nil, completion: { metadata, error in
            task.removeAllObservers()
            ProgressHUD.dismiss()
            if error != nil{
                print(error!.localizedDescription)
                completion(nil)
                return
            }
            
            storeageRef.downloadURL { url, error in
                guard let downloadurl = url else{
                    completion(nil)
                    return
                }
                completion(downloadurl.absoluteString)
            }
            
        })
        
        task.observe(.progress) { snapshot in
            let status = snapshot.progress!.completedUnitCount / snapshot.progress!.totalUnitCount
            
            ProgressHUD.showProgress(CGFloat(status))
        }
        
    }
    
    
    //save locally
    class func savefilelocally(filedata:NSData, filename:String){
       let docurl = getdocumentsurl().appendingPathComponent(filename, isDirectory: false)
        filedata.write(to: docurl, atomically: true)
        
    }
    
    class func downloadImageUrl(imageurl:String,completion:@escaping(_ img:UIImage?)->Void){
            

        let newName = (imageurl.components(separatedBy: "_").last?.components(separatedBy: "?").first?.components(separatedBy: ".").first)!
        print(newName)
        if fileexits(path: newName)
        {
            if let contentoffile = UIImage(contentsOfFile: fileInDocumentDirectory(name: newName))
            {
                completion(contentoffile)
            }else{
                completion(UIImage(named: "avatar"))
            }
        }else{
            
            if imageurl != "" {
                let docurl = URL(string: imageurl)
                let urlsess = URLSession.shared
                let datatask  = urlsess.dataTask(with: docurl!) { data, res, err in
                    if err == nil{
                        completion(UIImage(data: data!))

                    }else{
                        completion(UIImage(named: "avatar"))

                    }
                }
                datatask.resume()
            }
            
        }
        
    }
}


func fileInDocumentDirectory(name:String) -> String{
    return getdocumentsurl().appendingPathComponent(name).path
}

func getdocumentsurl() -> URL
{
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
}

func fileexits(path:String)->Bool{
    
    
    let filepath = fileInDocumentDirectory(name: path)
    let filemanager = FileManager.default.fileExists(atPath: filepath)
    
    return filemanager
}
