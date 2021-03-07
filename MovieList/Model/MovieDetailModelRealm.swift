//
//  MovieDetailModelRealm.swift
//  MovieList
//
//  Created by Sohaib Siddique on 07/03/2021.
//

import Foundation
import RealmSwift
import SwiftyJSON

class MovieDetail: Object {
    @objc dynamic var movieName:String = ""
    @objc dynamic var geners:String = ""
    @objc dynamic var date:String = ""
    @objc dynamic var overView:String = ""
    @objc dynamic var moviePoster:String = ""
    @objc dynamic var movieId:Int = 0
    
    override static func primaryKey() -> String? {
        return "movieName"
    }
    
    convenience init(movieName:String, geners:String, date:String, overView:String, moviePoster:String, movieId:Int) {
        self.init()
        self.movieName = movieName
        self.geners = geners
        self.date = date
        self.overView = overView
        self.moviePoster = moviePoster
        self.movieId = movieId
    }
    
}
