//
//  DetailViewModel.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import Foundation
class DetailViewModel{
    
    var completion: (() -> Void)?
    var photoResponseData: PhotoResponseData?
    var photoArray : [PhotoDetailData] = []
    
    var currentPage: Int = 1
    var searchTitle = ""
    var currentPrePage: Int = 0
    var isNeedLoadMore: Bool = true
    
    func addToFavorite(id: String, row: Int){
        print("Add to Favorite--> id: \(id), row: \(row)")
        let filterArray = photoArray.filter {
            $0.id == id
        }
        CoreDataHelper.shared.inster(id: filterArray[0].id, imgUrl: filterArray[0].urlString, title: filterArray[0].title)
    }
    
    func fetchSearchResult(text: String, pages: String, prePage: String){
        APIManager.shared.fetchSearchResult(text: text, pages: pages, prePage: prePage) { [weak self](error, data) in
            guard let strongSelf = self else { return }
            if let error = error{
                print(error.localizedDescription)
            }
            if let photoDataArray = data.photos?.photo, let page = data.photos?.page, let total = data.photos?.total{
                print("Page: \(page), Total: \(total)")
                if let totalInt = Int(total){
                    strongSelf.isNeedLoadMore = totalInt == 0 ? false : true
                }
                if strongSelf.currentPage == 1{
                    strongSelf.photoArray = photoDataArray
                }else{
                    strongSelf.photoArray += photoDataArray
                }
                if let callBack = strongSelf.completion{
                    callBack()
                }
            }
        }
    }
}
