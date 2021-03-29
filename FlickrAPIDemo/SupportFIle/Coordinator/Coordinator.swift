//
//  Coordinator.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import UIKit
protocol Coordinatable {
    var coordinator: Coordinator{get}
}
extension Coordinatable{
    var coordinator: Coordinator{
        return Coordinator.shared
    }
}
class Coordinator{
    
    static let shared = Coordinator()
    private init() {}
    
    enum Destination{
        enum TransitionType{
            case navigation
            case present
        }
        case search
        case detail(searchText: String, prePage: Int, photoArray: [PhotoDetailData])
        case favorite
    }
    
    func getViewController(destination: Destination) -> UIViewController{
        switch destination{
        case .search:
            return SearchViewController.initViewController()
        case .favorite:
            return FavoriteViewController.initViewController()
        case .detail(let searchText, let prePage, let photoData):
            return DetailViewController.initViewController(searchText: searchText, prePage: prePage, photoArray: photoData)
        }
    }
    func show(destination: Destination, sender: UIViewController, transitionType: Destination.TransitionType = .navigation){
        let targetVC = getViewController(destination: destination)
        showViewController(target: targetVC, sender: sender, transitionType: transitionType)
    }
    private func showViewController(target: UIViewController, sender: UIViewController?, transitionType: Destination.TransitionType){
         
         guard let sender = sender else {
             fatalError("You need to pass in a sender for .navigation or .present transitions")
         }
         switch transitionType{
         case .navigation:
             if let nav = sender.navigationController{
                 nav.pushViewController(target, animated: true)
             }else{
                 fatalError("why no navigationController")
             }
         case .present:
             sender.present(target, animated: true, completion: nil)
         }
     }
}
