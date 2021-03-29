//
//  DetailCollectionViewCell.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/27.
//

import UIKit
import Kingfisher
import SnapKit

class DetailCollectionViewCell: UICollectionViewCell {
    
    var didTappedFavorite: (((id: String, row: Int)) -> Void)?
    var didTappedDelete: (((id: String, row: Int)) -> Void)?
    
    private var currentRow = 0
    private var currentID = ""
    private var isAllReadyInFavorite: Bool = false
    
    private let photoImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .clear
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let namelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "--"
        return label
    }()
    
    private let favoriteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "iconFavoriteGray"), for: .normal)
        return btn
    }()
    
    private let deleteButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "iconClearGray"), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        isAllReadyInFavorite = false
        didTappedFavorite = nil
        didTappedDelete = nil
    }
}
extension DetailCollectionViewCell{
    func setUpUI(){
        self.backgroundColor = .white
        self.contentView.backgroundColor = .white
        
        self.contentView.addSubview(photoImageView)
        self.contentView.addSubview(namelabel)
        
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.75)
        }
        namelabel.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        self.contentView.addSubview(favoriteButton)
        self.contentView.addSubview(deleteButton)
        
        favoriteButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.top.equalToSuperview().offset(8)
            $0.size.equalTo(30)
        }
        deleteButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(8)
            $0.top.equalToSuperview().offset(8)
            $0.size.equalTo(30)
        }
        favoriteButton.addTarget(self, action: #selector(didTappedAddFavoriteButton), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(didTappedDeleteButton), for: .touchUpInside)
    }
    func config(text: String, imgUrl: String, row: Int, id: String){
        namelabel.text = text
        currentRow = row
        currentID = id
        deleteButton.isHidden = true
        isAllReadyInFavorite = CoreDataHelper.shared.inquire(id: id)
        
        self.setFavoriteButton(isHas: isAllReadyInFavorite)
        if let url = URL(string: imgUrl){
            self.photoImageView.setUpImage(with: url, placeholder: nil, errorPlaceholder: nil, completeBlock: nil)
        }
    }
    func configWithFavorite(text: String, imgUrl: String, row: Int, id: String){
        namelabel.text = text
        currentRow = row
        currentID = id
        favoriteButton.isHidden = true
        if let url = URL(string: imgUrl){
            self.photoImageView.setUpImage(with: url, placeholder: nil, errorPlaceholder: nil, completeBlock: nil)
        }
    }
    func setFavoriteButton(isHas: Bool){
        favoriteButton.setImage(isHas ? UIImage(named: "iconFavoriteColor") : UIImage(named: "iconFavoriteGray"), for: .normal)
    }
    @objc func didTappedAddFavoriteButton(){
        if !self.isAllReadyInFavorite{
            print("did Taped FavoriteButton")
            self.isAllReadyInFavorite = true
            self.setFavoriteButton(isHas: self.isAllReadyInFavorite)
            if let callBack = self.didTappedFavorite{
                callBack((id: self.currentID, row: self.currentRow))
            }
        }
    }
    @objc func didTappedDeleteButton(){
        print("did Taped deteleButton")
        if let callBack = self.didTappedDelete{
            callBack((id: self.currentID, row: self.currentRow))
        }
    }
}
