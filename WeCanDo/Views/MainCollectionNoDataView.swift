//
//  MainCollectionNoDataView.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/18.
//

import UIKit


protocol MainCollectionNoDataViewProtocol {
    func startEditItemViewController()
}


class MainCollectionNoDataView: UIView {
    
    var delegate: MainCollectionNoDataViewProtocol?
    
    lazy var addItemButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(" 목록추가", for: UIControl.State.normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.setImage(UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 12)), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(addItemTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func addItemTapped() {
        delegate?.startEditItemViewController()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            addItemButton.tintColor = .white
        } else {
            // 라이트모드
            addItemButton.tintColor = .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(addItemButton)
        addItemButton.translatesAutoresizingMaskIntoConstraints = false
        addItemButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        addItemButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
