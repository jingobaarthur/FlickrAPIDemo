//
//  FavoriteViewModel.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/29.
//

import Foundation
class FavoriteViewModel{
    var photoArray: [Photo] = []
    var completion: (() -> Void)?
    init() {
        CoreDataHelper.shared.completed = { [weak self](context) in
            guard let strongSelf = self else {return}
            strongSelf.didUpdate()
        }
    }
    func didUpdate(){
        self.photoArray = CoreDataHelper.shared.photoData
        if let callBack = self.completion{
            callBack()
        }
    }
    func loadFromCoreData(){
        CoreDataHelper.shared.load()
    }
    func delete(at row: Int, id: String){
        let filterArray = photoArray.filter {
            $0.id == id
        }
        CoreDataHelper.shared.delete(target: filterArray[0])
    }
}
