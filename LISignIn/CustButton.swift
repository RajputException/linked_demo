//
//  CustButton.swift
//  LISignIn
//
//  Created by Shubham on 30/07/18.
//  Copyright © 2018 Appcoda. All rights reserved.
//

import UIKit

class CustButton: UIButton {
    var isPressed = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("init frame called")
        initButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("init Decoder called")
        initButton()
    }
    
    func initButton()
    {
        print("init button called")
        layer.cornerRadius  = frame.size.height / 2
        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        layer.borderWidth = 1.0
        layer.backgroundColor = #colorLiteral(red: 0.5599316359, green: 0.9161403179, blue: 0.8393098712, alpha: 1)
        
    }

}
