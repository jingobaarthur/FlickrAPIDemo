//
//  CoreDataHelper.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/27.
//

import UIKit
import CoreData
class CoreDataHelper{
    static let shared = CoreDataHelper()
    private init() {}
    var completed: (([Photo]) -> Void)?
    var completedDelete: ((_ id: String) -> Void)?
    var photoData: [Photo] = []
    
    func appDelegate() -> AppDelegate{
        return UIApplication.shared.delegate as! AppDelegate
    }
    func getPersistentContainer() ->NSPersistentContainer{
        return appDelegate().persistentContainer
    }
    func managedObjectContext() -> NSManagedObjectContext {
        return getPersistentContainer().viewContext
    }
    func save(){
        appDelegate().saveContext()
    }
    func load(){
        let moc = managedObjectContext()
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        moc.performAndWait {
            do{
                let result = try moc.fetch(fetchRequest)
                if let callback = completed{
                    self.photoData = result
                    callback(result)
                }
            }catch{
                print("error \(error)")
            }
        }
    }
    func inquire(id: String) -> Bool{
        let moc = managedObjectContext()
        let fetchRequest = NSFetchRequest<Photo>(entityName: "Photo")
        var isAlreadyHas = false
        moc.performAndWait {
            do{
                let result = try moc.fetch(fetchRequest)
                for i in 0..<result.count{
                    if id == result[i].id{
                        isAlreadyHas = true
                        break
                    }else{
                        isAlreadyHas = false
                    }
                }
                
            }catch{
                print("error \(error)")
                isAlreadyHas = false
            }
        }
        return isAlreadyHas
    }
    func inster(id: String, imgUrl: String, title: String){
        let moc = managedObjectContext()
        let photo = Photo(context: moc)
        photo.id = id
        photo.imgUrl = imgUrl
        photo.title = title
        save()
        load()
    }
    func delete(target: Photo){
        let moc = managedObjectContext()
        moc.delete(target)
        save()
        load()
        if let callBack = self.completedDelete{
            callBack((target.id ?? ""))
        }
    }
}
