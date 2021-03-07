//
//  MovieModelRealm.swift
//  MovieList
//
//  Created by Sohaib Siddique on 07/03/2021.
//

import Foundation
import RealmSwift
import SwiftyJSON

class MoviesList: Object {
    @objc dynamic var movieName:String = ""
    @objc dynamic var moviePoster:String = ""
    @objc dynamic var movieId:Int = 0
    
    override static func primaryKey() -> String? {
        return "movieName"
    }
    
    convenience init(movieJSON: JSON) {
        self.init()
        self.movieName = movieJSON["title"].stringValue
        self.moviePoster = movieJSON["backdrop_path"].stringValue
        self.movieId = movieJSON["id"].intValue
    }
}
