//
//  UIHelper.swift
//  MovieList
//
//  Created by Sohaib Siddique on 06/03/2021.
//

import Foundation
import UIKit
import SDWebImage

struct Helper {
    init() {}
    static let sharedInstance = Helper()
    
    func imageLoading(imageView: UIImageView, url:String) {
        let replacedUrl = url.replacingOccurrences(of: " ", with: "+")
        imageView.sd_setImage(with: URL(string: replacedUrl)) { (image, err, cache, url) in
            if err != nil {
            } else {
                imageView.image = image
            }
        }
    }
    
    func formetDate(_ dateString:String) -> String {
        let serverDateFormatter = DateFormatter()
        serverDateFormatter.dateFormat = "yyyy-mm-dd"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        
        if let date = serverDateFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return ""
    }
}
