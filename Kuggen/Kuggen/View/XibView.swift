//
//  XibView.swift
//  Kuggen
//
//  Created by Tove Ekman on 2019-03-15.
//  Copyright © 2019 Four-in-one. All rights reserved.
//

import UIKit

class XibView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetupView(name: className)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetupView(name: className)
    }
}

extension UIView {
    
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func xibSetupView(name: String) {
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            print("Could not load nib named \(name).")
            fatalError()
        }
        
        view.frame = bounds
        addSubview(view)
    }
}

extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
}
