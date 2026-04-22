//
//  UIApplication+Extension.swift
//  Pungdeong
//
//  Created by sun on 4/21/26.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil,
                   from: nil,
                   for: nil)
    }
}
