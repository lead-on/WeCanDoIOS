//
//  DetailTableCell.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/18.
//

import UIKit


protocol DetailTableCellProtocol {
    func setEditMode(subItem: SubItem)
    func setFinished(subItem: SubItem, isFinished: Bool)
    func editText(subItem: SubItem, text: String)
}


class DetailTableCell: UITableViewCell {
    
    var delegate: DetailTableCellProtocol?
    
    var subItem: SubItem? {
        didSet {
            guard let subItem = self.subItem else { return }
            editTV.text = subItem.description
            
            if !subItem.isEditMode {
                descLabel.isHidden = false
//                editTV.isHidden = true
                editTVView.isHidden = true
            }
            
            let attributeString = NSMutableAttributedString(string: subItem.description!)
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
            if !subItem.isFinished {
                attributeString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            }
            descLabel.attributedText = attributeString
            
            descLabel.removeFromSuperview()
            if subItem.isSortMode {
                addSubview(descLabel)
                descLabel.translatesAutoresizingMaskIntoConstraints = false
                descLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                descLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -65).isActive = true
                descLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
                descLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
                descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
                
            } else {
                addSubview(descLabel)
                descLabel.translatesAutoresizingMaskIntoConstraints = false
                descLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
                descLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
                descLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
                descLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
                descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
            }
        }
    }
    
    lazy var descLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0 // 이거 해야 \n 개행됨
        label.lineBreakMode = .byWordWrapping // word line break
        return label
    }()
    
    lazy var clearButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(textClear), for: UIControl.Event.touchUpInside)
        button.tintColor = .systemGray
        return button
    }()
    lazy var editTV: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .tertiarySystemGroupedBackground
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 0);
        tv.font = UIFont.systemFont(ofSize: 15)
        tv.delegate = self
        return tv
    }()
    lazy var editTVView: UIView = {
        let view = UIView()
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        clearButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        clearButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        clearButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
        view.addSubview(editTV)
        editTV.translatesAutoresizingMaskIntoConstraints = false
        editTV.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        editTV.rightAnchor.constraint(equalTo: clearButton.leftAnchor, constant: -15).isActive = true
        editTV.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        editTV.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        return view
    }()
    
    @objc func selfTapped() {
        guard let subItem = self.subItem else { return }
        if subItem.isFinished { return }
        if subItem.isSortMode { return }
        
        self.subItem?.isEditMode = true
        descLabel.isHidden = true
//        editTV.isHidden = false
        editTVView.isHidden = false
        editTV.becomeFirstResponder()
        
        delegate?.setEditMode(subItem: subItem)
    }
    
    @objc func selfDoubleTapped() {
        guard let subItem = self.subItem else { return }
        // 이거 막으면 더블클릭이 안먹음 (더블클릭 시점에 이미 editmode로 들어오기 때문)
//        if subItem.isEditMode { return }
        if subItem.isSortMode { return }
        
        delegate?.setFinished(subItem: subItem, isFinished: !subItem.isFinished)
    }
    
    @objc func textClear() {
        guard let subItem = self.subItem else { return }
        editTV.text = ""
        delegate?.editText(subItem: subItem, text: "")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(editTVView)
        editTVView.translatesAutoresizingMaskIntoConstraints = false
        editTVView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        editTVView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        editTVView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        editTVView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        editTVView.isHidden = true
        
//        addSubview(editTV)
//        editTV.translatesAutoresizingMaskIntoConstraints = false
//        editTV.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        editTV.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        editTV.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        editTV.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        editTV.isHidden = true
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(selfDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension DetailTableCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let subItem = self.subItem else { return }
        delegate?.editText(subItem: subItem, text: textView.text!)
    }
}
