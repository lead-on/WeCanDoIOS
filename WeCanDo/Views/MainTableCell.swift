//
//  MainTableCell.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


protocol MainTableCellProtocol {
    func detailItem()
    func removeItem()
}


class MainTableCell: UITableViewCell {
    
    var delegate: MainTableCellProtocol?
    
    var item: Item? {
        didSet {
            guard let item = self.item else { return }

            self.titleLabel.text = item.title
            self.countLabel.text = String(item.count!)

            if item.editMode {
                menuIV.removeFromSuperview()
                titleLabel.removeFromSuperview()
                
                containerView.addSubview(removeIV)
                removeIV.translatesAutoresizingMaskIntoConstraints = false
                removeIV.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                removeIV.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 6).isActive = true
                removeIV.heightAnchor.constraint(equalToConstant: 20).isActive = true
                removeIV.widthAnchor.constraint(equalToConstant: 20).isActive = true
                
                containerView.addSubview(menuIV)
                menuIV.translatesAutoresizingMaskIntoConstraints = false
                menuIV.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                menuIV.leftAnchor.constraint(equalTo: removeIV.rightAnchor, constant: 6).isActive = true
                menuIV.heightAnchor.constraint(equalToConstant: 30).isActive = true
                menuIV.widthAnchor.constraint(equalToConstant: 30).isActive = true
                
                containerView.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                titleLabel.leftAnchor.constraint(equalTo: menuIV.rightAnchor, constant: 10).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -139).isActive = true
                
            } else {
//                menuIV.leftAnchor.constraint(equalTo: leftAnchor, constant: 13).isActive = true
                removeIV.removeFromSuperview()
                menuIV.removeFromSuperview()
                titleLabel.removeFromSuperview()
                
                containerView.addSubview(menuIV)
                menuIV.translatesAutoresizingMaskIntoConstraints = false
                menuIV.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                menuIV.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 13).isActive = true
                menuIV.heightAnchor.constraint(equalToConstant: 30).isActive = true
                menuIV.widthAnchor.constraint(equalToConstant: 30).isActive = true
                
                containerView.addSubview(titleLabel)
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
                titleLabel.leftAnchor.constraint(equalTo: menuIV.rightAnchor, constant: 10).isActive = true
                titleLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -120).isActive = true
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
        return iv
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 4
        
        view.addSubview(arrowIV)
        arrowIV.translatesAutoresizingMaskIntoConstraints = false
        arrowIV.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        arrowIV.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -13).isActive = true
        
        view.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        countLabel.rightAnchor.constraint(equalTo: arrowIV.leftAnchor, constant: -5).isActive = true
        
        return view
    }()
    
    @objc func selfTapped() {
        guard let item = self.item else { return }
        
        if item.editMode {
            delegate?.removeItem()
        } else {
            delegate?.detailItem()
        }
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
        } else {
            // 라이트모드
            menuIV.image = UIImage(systemName: "line.horizontal.3.circle.fill")
            arrowIV.tintColor = .black
            removeIV.image = UIImage(systemName: "minus.circle.fill")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tertiarySystemGroupedBackground
        
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32).isActive = true
        containerView.heightAnchor.constraint(equalTo: heightAnchor, constant: -16).isActive = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
        adjustColors()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
