//
//  APIManager.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import Foundation
import Alamofire
class APIManager: NSObject{
    
    static let shared = APIManager()
    private override init() {}
    static let requestServer = RequestService()
    
    func fetchSearchResult(text: String, pages: String, prePage: String,
                           completion: @escaping (_ error:Error?, _ result: PhotoResponseData) -> Void){
        let parameters: Parameters = ["text":text, "per_page": prePage, "page": pages]
        APIManager.requestServer.getRequest(path: RequestService.APIRouter.search.path, parameter: parameters, resultType: PhotoResponseData.self) { (error, response) in
            DispatchQueue.main.async {
                if let responseData = response{
                    completion(error, responseData)
                }
            }
        }
    }
}
