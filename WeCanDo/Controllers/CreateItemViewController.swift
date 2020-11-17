//
//  CreateItemViewController.swift
//  WeCanDo
//
//  Created by 서원영 on 2020/11/17.
//

import UIKit


class CreateItemViewController: UIViewController {
    
    var colorPickerSpacing: CGFloat = 12
    let colorPickerViews: [ColorPickerView] = [
        ColorPickerView(index: 0, hexCode: "#ED1D24"),
        ColorPickerView(index: 1, hexCode: "#F25A23"),
        ColorPickerView(index: 2, hexCode: "#FBB03C"),
        ColorPickerView(index: 3, hexCode: "#8BC540"),
        ColorPickerView(index: 4, hexCode: "#1DB54A"),
        ColorPickerView(index: 5, hexCode: "#54CCFF"),
        ColorPickerView(index: 6, hexCode: "#0073FD"),
        ColorPickerView(index: 7, hexCode: "#653E91"),
        ColorPickerView(index: 8, hexCode: "#808080"),
        ColorPickerView(index: 9, hexCode: "#000000"),
        ColorPickerView(index: 10, hexCode: "#C59C6D"),
        ColorPickerView(index: 11, hexCode: "#754B23")
    ]
    var selectedColorPickerIndex: Int?
    
    lazy var menuIV: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 60
        return iv
    }()
    
    lazy var nameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "항목명을 입력해주세요"
        tf.textAlignment = .center
        tf.font = UIFont.systemFont(ofSize: 24)
        return tf
    }()
    
    lazy var nameTFView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 4
        view.backgroundColor = .systemBackground
        
        view.addSubview(nameTF)
        nameTF.translatesAutoresizingMaskIntoConstraints = false
        nameTF.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameTF.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        nameTF.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        nameTF.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        
        return view
    }()
    
    lazy var colorPickerContainerView: UIView = {
        let view = UIView()
        
        for (index, colorPickerView) in colorPickerViews.enumerated() {
            colorPickerView.parentVC = self
            
            view.addSubview(colorPickerView)
            colorPickerView.translatesAutoresizingMaskIntoConstraints = false
            colorPickerView.widthAnchor.constraint(equalToConstant: ((self.view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)).isActive = true
            colorPickerView.heightAnchor.constraint(equalToConstant: ((self.view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)).isActive = true
            
            if index < 6 {
                colorPickerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            } else {
                colorPickerView.topAnchor.constraint(equalTo: colorPickerViews[index - 6].bottomAnchor, constant: colorPickerSpacing).isActive = true
            }
            
            if index == 0 || index == 6 {
                colorPickerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            } else {
                colorPickerView.leftAnchor.constraint(equalTo: colorPickerViews[index - 1].rightAnchor, constant: colorPickerSpacing).isActive = true
            }
            
            colorPickerView.delegate = self
        }
        
        return view
    }()
    
    lazy var colorSelectView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = ((((self.view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)) + 8) / 2
        return view
    }()
    
    @objc func createItem() {
        let name = nameTF.text
        let hexCode = colorPickerViews[selectedColorPickerIndex!].hexCode
        print(name! + ", " + hexCode!)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        adjustColors()
    }
    func adjustColors() {
        if self.traitCollection.userInterfaceStyle == .dark {
            // 다크모드
            menuIV.image = UIImage(systemName: "line.horizontal.3.circle")
        } else {
            // 라이트모드
            menuIV.image = UIImage(systemName: "line.horizontal.3.circle.fill")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .tertiarySystemGroupedBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.plain, target: self, action: #selector(createItem))
        
        view.addSubview(menuIV)
        menuIV.translatesAutoresizingMaskIntoConstraints = false
        menuIV.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        menuIV.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuIV.widthAnchor.constraint(equalToConstant: 120).isActive = true
        menuIV.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        view.addSubview(nameTFView)
        nameTFView.translatesAutoresizingMaskIntoConstraints = false
        nameTFView.topAnchor.constraint(equalTo: menuIV.bottomAnchor, constant: 30).isActive = true
        nameTFView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTFView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 40).isActive = true
        nameTFView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        view.addSubview(colorPickerContainerView)
        colorPickerContainerView.translatesAutoresizingMaskIntoConstraints = false
        colorPickerContainerView.topAnchor.constraint(equalTo: nameTFView.bottomAnchor, constant: 40).isActive = true
        colorPickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        colorPickerContainerView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 60).isActive = true
        colorPickerContainerView.heightAnchor.constraint(equalToConstant: ((((self.view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)) * 2) + colorPickerSpacing).isActive = true
        
        configureMenuIVColor()
        
        self.hideKeyboardWhenTappedAround()
//        self.moveViewWithKeyboard()
        
        adjustColors()
    }
    
    
    func configureMenuIVColor() {
        let randomColorPickerView = colorPickerViews.randomElement()
        menuIV.tintColor = UIColor(hexString: (randomColorPickerView?.hexCode)!)
        
        view.addSubview(colorSelectView)
        colorSelectView.translatesAutoresizingMaskIntoConstraints = false
        colorSelectView.centerYAnchor.constraint(equalTo: randomColorPickerView!.centerYAnchor).isActive = true
        colorSelectView.centerXAnchor.constraint(equalTo: randomColorPickerView!.centerXAnchor).isActive = true
        colorSelectView.widthAnchor.constraint(equalToConstant: (((view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)) + 8).isActive = true
        colorSelectView.heightAnchor.constraint(equalToConstant: (((view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)) + 8).isActive = true
        
        selectedColorPickerIndex = randomColorPickerView?.index
    }
}


extension CreateItemViewController: ColorPickerViewProtocol {
    func selectColor(index: Int, hexCode: String) {
        menuIV.tintColor = UIColor(hexString: hexCode)
        colorSelectView.removeFromSuperview()
        
        view.addSubview(colorSelectView)
        colorSelectView.translatesAutoresizingMaskIntoConstraints = false
        colorSelectView.centerYAnchor.constraint(equalTo: colorPickerViews[index].centerYAnchor).isActive = true
        colorSelectView.centerXAnchor.constraint(equalTo: colorPickerViews[index].centerXAnchor).isActive = true
        colorSelectView.widthAnchor.constraint(equalToConstant: (((view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)) + 8).isActive = true
        colorSelectView.heightAnchor.constraint(equalToConstant: (((view.frame.size.width - 60) / 6) - ((colorPickerSpacing * 5) / 6)) + 8).isActive = true
        
        selectedColorPickerIndex = index
    }
}
