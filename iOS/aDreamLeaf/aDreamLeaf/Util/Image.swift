//
//  Image.swift
//  aDreamLeaf
//
//  Created by 엄태양 on 2023/06/30.
//

import Foundation
import UIKit

struct Image {
    static func imgToBase64 (with image: UIImage?) -> String? {
        if image == nil {
            return nil
        } else {
            let imageData:NSData = image!.pngData()! as NSData
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            return strBase64
        }
    }
    
    static func base64ToImg(with base64: String?) -> UIImage? {
        if base64 == nil {
            return nil
        } else {
            let dataDecoded : Data = Data(base64Encoded: base64!, options: .ignoreUnknownCharacters)!
            let decodedimage = UIImage(data: dataDecoded)
            return decodedimage
        }
        
    }
}
