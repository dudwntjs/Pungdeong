//
//  Image+Data.swift
//  Pungdeong
//
//  Created by sun on 4/20/26.
//

import UIKit

extension UIImage {
    func toData() -> Data? {
        self.jpegData(compressionQuality: 0.8)
    }
}

extension Data {
    func toImage() -> UIImage? {
        UIImage(data: self)
    }
}
