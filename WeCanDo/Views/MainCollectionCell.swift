//
//  MainCollectionCell.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


protocol MainCollectionCellProtocol {
    func removeItem()
    func startEditItemViewController()
}


class MainCollectionCell: UICollectionViewCell {
    
    var delegate: MainCollectionCellProtocol?
    
    var item: Item? {
        didSet {
            guard let item = self.item else { return }
            
            self.titleLabel.text = item.title
            self.countLabel.text = String(item.count!)
            
            if item.editMode {
                menuIV.removeFromSuperview()
                titleLabel.removeFromSuperview()
                arrowIV.removeFromSuperview()
                countLabel.removeFromSuperview()
                editButton.removeFromSuperview()
                
                addSubview(removeIV)
                removeIV.translatesAutoresizingMaskIntoConstraints = false
                removeIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                removeIV.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
                removeIV.heightAnchor.constraint(equalToConstant: 20).isActive = true
                removeIV.widthAnchor.constraint(equalToConstant: 20).isActive = true
                
                addSubview(menuIV)
                menuIV.translatesAutoresizingMaskIntoConstraints = false
                menuIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                menuIV.leftAnchor.constraint(equalTo: removeIV.rightAnchor, constant: 5).isActive = true
                menuIV.heightAnchor.constraint(equalToConstant: 30).isActive = true
                menuIV.widthAnchor.constraint(equalToConstant: 30).isActive = true
                
                addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                titleLabel.leftAnchor.constraint(equalTo: menuIV.rightAnchor, constant: 15).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -145).isActive = true
                
                addSubview(editButton)
                editButton.translatesAutoresizingMaskIntoConstraints = false
                editButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
                
                
            } else {
//                menuIV.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
                removeIV.removeFromSuperview()
                menuIV.removeFromSuperview()
                titleLabel.removeFromSuperview()
                arrowIV.removeFromSuperview()
                countLabel.removeFromSuperview()
                editButton.removeFromSuperview()
                
                addSubview(menuIV)
                menuIV.translatesAutoresizingMaskIntoConstraints = false
                menuIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                menuIV.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
                menuIV.heightAnchor.constraint(equalToConstant: 30).isActive = true
                menuIV.widthAnchor.constraint(equalToConstant: 30).isActive = true
                
                addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                titleLabel.leftAnchor.constraint(equalTo: menuIV.rightAnchor, constant: 15).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -130).isActive = true
                
                addSubview(arrowIV)
                arrowIV.translatesAutoresizingMaskIntoConstraints = false
                arrowIV.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                arrowIV.rightAnchor.constraint(equalTo: rightAnchor, constant: -15).isActive = true
                
                addSubview(countLabel)
                countLabel.translatesAutoresizingMaskIntoConstraints = false
                countLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                countLabel.rightAnchor.constraint(equalTo: arrowIV.leftAnchor, constant: -5).isActive = true
            }
        }
    }
    
    lazy var menuIV: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .systemGreen
        iv.layer.cornerRadius = 15
        return iv
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var arrowIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "chevron.right")
        return iv
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var removeIV: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .systemRed
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(removeIVTapped)))
        return iv
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("수정", for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(editButtonTapped), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    @objc func removeIVTapped() {
        delegate?.removeItem()
    }
    
    @objc func editButtonTapped() {
        delegate?.startEditItemViewController()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            menuIV.image = UIImage(systemName: "line.horizontal.3.circle")
            arrowIV.tintColor = .white
            removeIV.image = UIImage(systemName: "minus.circle")
            editButton.tintColor = .white
        } else {
            // 라이트모드
            menuIV.image = UIImage(systemName: "line.horizontal.3.circle.fill")
            arrowIV.tintColor = .black
            removeIV.image = UIImage(systemName: "minus.circle.fill")
            editButton.tintColor = .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 4
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
