//
//  SearchViewModel.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import Foundation
class SearchViewModel{
    
    
    var photoArray : [PhotoDetailData] = []
    var completion: (() -> Void)?
    
    func fetchSearchResult(text: String, pages: String, prePage: String){
        APIManager.shared.fetchSearchResult(text: text, pages: pages, prePage: prePage) { [weak self](error, data) in
            guard let strongSelf = self else { return }
            if let error = error{
                print(error.localizedDescription)
            }
            if let photoDataArray = data.photos?.photo{
                strongSelf.photoArray = photoDataArray
                if let callBack = strongSelf.completion{
                    callBack()
                }else{
                    print("Something error...")
                }
            }
        }
    }
}
