//
//  MainCollectionCell.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


protocol MainCollectionCellProtocol {
    func removeItem(indexPath: IndexPath)
    func startEditItemViewController(item: Item, indexPath: IndexPath)
    func startDetailTableViewController()
}


class MainCollectionCell: UICollectionViewCell {
    
    var delegate: MainCollectionCellProtocol?
    
    var indexPath: IndexPath?
    var item: Item? {
        didSet {
            guard let item = self.item else { return }
            
            self.titleLabel.text = item.title
            self.countLabel.text = String(item.count!)
            self.menuIV.tintColor = UIColor(hexString: item.hexCode!)
            
            // 편집모드인지 확인 후 뷰 세팅
            if item.isEditMode {
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
    
    var isDragMode: Bool? {
        didSet {
            guard let isDragMode = self.isDragMode else { return }
            if isDragMode {
                self.layer.shadowRadius = 4 // 그림자 크기
            } else {
                self.layer.shadowRadius = 0 // 그림자 크기
            }
        }
    }
    
    lazy var menuIV: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "line.horizontal.3.circle.fill")
//        iv.tintColor = UIColor(hexString: "#000000")
        iv.layer.cornerRadius = 15
        iv.backgroundColor = .white
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
        iv.image = UIImage(systemName: "minus.circle.fill")
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
        guard let indexPath = self.indexPath else { return }
        delegate?.removeItem(indexPath: indexPath)
    }
    
    @objc func editButtonTapped() {
        guard let item = self.item else { return }
        guard let indexPath = self.indexPath else { return }
        delegate?.startEditItemViewController(item: item, indexPath: indexPath)
    }
    
    @objc func selfTapped() {
        guard let item = self.item else { return }
        if item.isEditMode { return }
        delegate?.startDetailTableViewController()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            arrowIV.tintColor = .white
            editButton.tintColor = .white
        } else {
            // 라이트모드
            arrowIV.tintColor = .black
            editButton.tintColor = .black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 4
        self.layer.shadowColor = UIColor.black.cgColor // 그림자 색
        self.layer.shadowOpacity = 0.5 // 그림자 진함 정도
        self.layer.shadowOffset = CGSize(width: 0, height: 0) // 그림자 시작 위치 (x,y)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
