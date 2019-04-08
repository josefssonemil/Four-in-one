//
//  MenuButton.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-15.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

@IBDesignable class MenuButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 10 {
        didSet { sharedInit() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        sharedInit()
    }

    private func sharedInit() {
        backgroundColor = .midPrimary
        setTitleColor(.lightText, for: .normal)
        titleEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        refreshCorners(value: cornerRadius)
    }
    
    private func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
}
