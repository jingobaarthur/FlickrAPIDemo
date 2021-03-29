//
//  RequestService.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import Foundation
import Alamofire
class RequestService{
    
   private enum APIError: Error{
        case noData
        case decoreError
        case domainError
        
        func errorMassage() -> String{
            switch self{
            case .noData:
                return "Do not have data in this response,"
            case .decoreError:
                return "Decode error,"
            case .domainError:
                return "Domain error,"
            }
        }
    }

    
    enum APIRouter{
        static let baseUrl = "https://www.flickr.com/services/rest/"
        static let method = "?method=flickr.photos.search&api_key=6cfad9429d351aedd33167de5fb64f2d"
        static let format = "&format=json&nojsoncallback=1"
        case search
        var path: String{
            switch self{
            case .search:
                return APIRouter.baseUrl + APIRouter.method + APIRouter.format
            }
        }
    }
    
    private lazy var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 6
        let manger = Session(configuration: configuration)
        //manger.adapter = CustomAdapter()
        return manger
    }()
}
extension RequestService{
    func getRequest<T:Codable>(path: String,
                               parameter: Parameters? = nil,
                               resultType:T.Type,
                               method:HTTPMethod = .get,
                               encoding: ParameterEncoding = URLEncoding.default,
                               completion: @escaping (_ error:Error?, _ result: T?) -> Void){
        
        self.basicRequest(path: path, parameter: parameter, resultType: resultType, method: method, encoding: encoding, completion: completion)
    }
    func postRequest<T:Codable>(path: String,
                                parameter: Parameters? = nil,
                                resultType:T.Type,
                                method:HTTPMethod = .post,
                                encoding: ParameterEncoding = URLEncoding.default,
                                completion: @escaping (_ error:Error?, _ result: T?) -> Void){
        self.basicRequest(path: path, parameter: parameter, resultType: resultType, method: method, encoding: encoding, completion: completion)
    }
    func basicRequest<T:Codable>(path: String, parameter: Parameters? = nil, resultType: T.Type, method: HTTPMethod, encoding: ParameterEncoding = URLEncoding.default, completion: @escaping (_ error:Error?, _ result: T?) -> Void){
        
        let para = self.transPara(parameters: parameter)
        print("API URL: \(path), \nParameters: \(para), \nMethod: \(method)")
        let task = self.sessionManager.request(path, method: method, parameters: para, encoding: encoding).responseJSON { (response) in
            
            if let error = response.error{
                return completion(error, nil)
            }
            
            if let statusCode = response.response?.statusCode{
                print("Status Code: \(statusCode)")
            }
            
            guard let data = response.data else {
                return completion(APIError.noData, nil)
            }
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(nil, result)
            }catch{
                return completion(APIError.decoreError, nil)
            }
            
        }
        task.resume()
    }
    func transPara(parameters : Parameters? , modify:Bool = true) -> Parameters{
        var newParameters: Parameters = [String: Any]()
        if let data = parameters
        {
            for name in data.keys {
                newParameters[name] = data[name]
            }
            
        }
        if modify == true
        {
            
        }
        return newParameters
    }
}
