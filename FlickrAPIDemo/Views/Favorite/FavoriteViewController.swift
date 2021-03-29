//
//  FavoriteViewController.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/29.
//

import UIKit
import SnapKit

class FavoriteViewController: BaseViewController {
    
    fileprivate let viewModel = FavoriteViewModel()
    
    private lazy var collectionView = UICollectionView()
    private var layout = UICollectionViewFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setBinding()
        viewModel.loadFromCoreData()
    }
    static func initViewController() -> FavoriteViewController{
        let vc = FavoriteViewController()
        return vc
    }
    override func setUpUI() {
        super.setUpUI()
        self.view.backgroundColor = .white
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width / 2) - 10, height: (UIScreen.main.bounds.width / 2) + 15)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 5, bottom: 0, right: 5)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundView?.isHidden = true
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: "DetailCollectionViewCell")
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    override func setBinding() {
        super.setBinding()
        viewModel.completion = { [weak self] in
            guard let strongSelf = self else {return}
            print("Loading from CoreData")
            strongSelf.collectionView.reload {}
        }
    }
}
extension FavoriteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.configWithFavorite(text: viewModel.photoArray[indexPath.item].title ?? "", imgUrl: viewModel.photoArray[indexPath.item].imgUrl ?? "", row: indexPath.item, id: viewModel.photoArray[indexPath.item].id ?? "")
        cell.didTappedDelete = { [weak self] (callback) in
            guard let strongSelf = self else {return}
            strongSelf.viewModel.delete(at: callback.row, id: callback.id)
        }
        return cell
    }

}
