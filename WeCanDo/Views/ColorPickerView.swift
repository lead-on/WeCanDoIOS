//
//  ColorPickerView.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


protocol ColorPickerViewProtocol {
    func selectColor(index: Int, hexCode: String)
}


class ColorPickerView: UIView {
    
    var delegate: ColorPickerViewProtocol?
    
    var index: Int?
    var hexCode: String?
    
    var parentVC: CreateItemViewController? {
        didSet {
            guard let parentVC = self.parentVC else { return }
            self.layer.cornerRadius = (((parentVC.view.frame.size.width - 60) / 6) - ((parentVC.colorPickerSpacing * 5) / 6)) / 2
        }
    }
    
    @objc func selfTapped() {
        guard let index = self.index else { return }
        guard let hexCode = self.hexCode else { return }
        delegate?.selectColor(index: index, hexCode: hexCode)
    }
    
    init(index: Int, hexCode: String) {
        super.init(frame: CGRect.zero)
        
        self.index = index
        self.hexCode = hexCode
        
        self.backgroundColor = UIColor(hexString: hexCode)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
