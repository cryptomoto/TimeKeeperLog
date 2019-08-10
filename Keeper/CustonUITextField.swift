//
//  CustonUITextField.swift
//  Keeper
//
//  Created by admin on 6/29/16.
//  Copyright © 2016 ekzntsv. All rights reserved.
//

import Foundation
import UIKit  // don't forget this

class CustomUITextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
