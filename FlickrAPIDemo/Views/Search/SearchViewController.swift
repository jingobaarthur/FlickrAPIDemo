//
//  ViewController.swift
//  FlickrAPIDemo
//
//  Created by Arthur on 2021/3/26.
//

import UIKit
import SnapKit

class SearchViewController: BaseViewController {
    
    fileprivate let viewModel = SearchViewModel()
    
    /*搜尋內容*/
    private lazy var contentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "欲搜尋內容"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        return textField
    }()
    /*每頁筆數*/
    private lazy var prePageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "每頁愈呈現數量"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldAction), for: .editingChanged)
        return textField
    }()
    /*搜尋*/
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("搜尋", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.isEnabled = false
        button.addTarget(self, action: #selector(didTappedSearchButton), for: .touchUpInside)
        return button
    }()
    
    private var stackView: UIStackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        textFieldAction()
        setBinding()
    }
    
    override func setUpUI() {
        super.setUpUI()
        
        self.view.backgroundColor = .white
        
        stackView = UIStackView(arrangedSubviews: [contentTextField, prePageTextField,searchButton])
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 30
        stackView.backgroundColor = .clear
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
        }
        
        contentTextField.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 0.7)
            $0.height.equalTo(30)
        }
        prePageTextField.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 0.7)
            $0.height.equalTo(30)
        }
        searchButton.snp.makeConstraints {
            $0.width.equalTo(UIScreen.main.bounds.width * 0.7)
            $0.height.equalTo(30)
        }
        
    }
    
    override func setBinding() {
        super.setBinding()
        viewModel.completion = { [weak self] in
            print("DidFinish fetch photo data")
            guard let strongSelf = self else { return }
            if let contentString = strongSelf.contentTextField.text, let page = strongSelf.prePageTextField.text{
                strongSelf.contentTextField.text = ""
                strongSelf.prePageTextField.text = ""
                strongSelf.showDetailVC(searchText: contentString, prePage: page)
            }
        }
    }
    static func initViewController() -> SearchViewController{
        let vc = SearchViewController()
        return vc
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    deinit {
        print("SearchVC was deinit")
    }
}
//MARK: Action
extension SearchViewController{
    @objc func textFieldAction(){
        if let contentString = self.contentTextField.text, let page = self.prePageTextField.text{
            let btnEnable = contentString.count > 0 && page.count > 0
            changeButtonStatus(isEnable: btnEnable)
        }
    }
    @objc func didTappedSearchButton(){
        print("Did Tapped SearchButton")
        if let searchString = self.contentTextField.text, let prePage = self.prePageTextField.text{
            changeButtonStatus(isEnable: false)
            self.view.endEditing(true)
            viewModel.fetchSearchResult(text: searchString, pages: "\(1)", prePage: prePage)
        }
    }
    func changeButtonStatus(isEnable: Bool){
        searchButton.isEnabled = isEnable
        searchButton.backgroundColor = isEnable ? UIColor.blue : UIColor.lightGray
    }
}
//MARK: Coordinate
extension SearchViewController{
    func showDetailVC(searchText: String, prePage: String){
        guard let prePage = Int(prePage) else {return}
        coordinator.show(destination: .detail(searchText: searchText, prePage: prePage, photoArray: viewModel.photoArray), sender: self, transitionType: .navigation)
    }
}
//MARK: UITextField delegate
extension SearchViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
