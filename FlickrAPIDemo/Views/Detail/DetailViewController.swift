//
//  DetailViewController.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import UIKit

class DetailViewController: BaseViewController {
    
    fileprivate let viewModel = DetailViewModel()
    
    private lazy var collectionView = UICollectionView()
    private var layout = UICollectionViewFlowLayout()
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didPullDownToReload), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setBinding()
    }
    static func initViewController(searchText: String, prePage: Int, photoArray: [PhotoDetailData]) -> DetailViewController{
        let vc = DetailViewController()
        vc.viewModel.searchTitle = searchText
        vc.viewModel.currentPrePage = prePage
        vc.viewModel.photoArray = photoArray
        return vc
    }
    override func setUpUI() {
        super.setUpUI()
        title = "搜尋結果: " + viewModel.searchTitle
        print("搜尋結果: \(viewModel.searchTitle), prePage: \(viewModel.currentPrePage)")
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
        collectionView.refreshControl = refreshControl
    }
    override func setBinding() {
        super.setBinding()
        viewModel.completion = { [weak self] in
            print("Did finish fetch photo data")
            guard let strongSelf = self else {return}
            strongSelf.refreshControl.endRefreshing()
            strongSelf.collectionView.reload {}
        }
        CoreDataHelper.shared.completedDelete = { [weak self](id)in
            guard let strongSelf = self else {return}
            strongSelf.collectionView.reload {}
            //strongSelf.collectionView.reloadItems(at: <#T##[IndexPath]#>)
        }
    }
    deinit {
        print("DetailVC was deinit")
    }
}
extension DetailViewController{
    @objc func didPullDownToReload(){
        print("Pull down to reload")
        viewModel.currentPage = 1
        viewModel.fetchSearchResult(text: viewModel.searchTitle, pages: "\(viewModel.currentPage)", prePage: "\(viewModel.currentPrePage)")
    }
}
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailCollectionViewCell", for: indexPath) as! DetailCollectionViewCell
        cell.config(text: viewModel.photoArray[indexPath.item].title, imgUrl: viewModel.photoArray[indexPath.item].urlString, row: indexPath.item, id: viewModel.photoArray[indexPath.item].id)
        cell.didTappedFavorite = { [weak self] (callback) in
            guard let strongSelf = self else {return}
            strongSelf.viewModel.addToFavorite(id: callback.id, row: callback.row)
        }
        return cell
    }
}
extension DetailViewController: UIScrollViewDelegate{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.contentSize.height > collectionView.frame.height else {return}
        if scrollView.contentSize.height - (scrollView.frame.size.height + scrollView.contentOffset.y) <= -10 {
            print("Pull up to load more")
            if viewModel.isNeedLoadMore{
                viewModel.currentPage += 1
                viewModel.fetchSearchResult(text: viewModel.searchTitle, pages: "\(viewModel.currentPage)", prePage: "\(viewModel.currentPrePage)")
            }
        }
    }
}
