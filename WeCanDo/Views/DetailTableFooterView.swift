//
//  DetailTableHeaderCell.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/18.
//

import UIKit


protocol DetailTableFooterViewProtocol {
    func addSubItem()
}


class DetailTableFooterView: UIView {
    
    var delegate: DetailTableFooterViewProtocol?
    
    lazy var addSubItemButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle(" 새로운 할일", for: UIControl.State.normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setImage(UIImage(systemName: "plus.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 18)), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(addSubItemTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func addSubItemTapped() {
        delegate?.addSubItem()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            addSubItemButton.tintColor = .white
        } else {
            // 라이트모드
            addSubItemButton.tintColor = .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(addSubItemButton)
        addSubItemButton.translatesAutoresizingMaskIntoConstraints = false
        addSubItemButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        addSubItemButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
