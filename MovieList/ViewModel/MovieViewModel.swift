//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Sohaib Siddique on 06/03/2021.
//

import Foundation
import Alamofire
import SVProgressHUD
import SwiftyJSON
import RealmSwift

class MovieViewModel {
    
    weak var movieVC:ViewController?
    weak var detailVC:DetailViewController?
    
    var arrayTrailerResult:[ResultsTrailer] = []
    
    var totalResult:Int = 0
    
    let realm = try! Realm()
    
    //MARK:- Get movie list
    func getMovies(pageNo:Int) {
        SVProgressHUD.show()
        let urlString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.apiKey)&page=\(pageNo)"
        AF.request(urlString, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                var movies = [MoviesList]()
                let jsonData:JSON = JSON(data)
                self.totalResult = jsonData["total_results"].intValue
                let jsonArray = jsonData["results"].arrayValue
                
                for movieJson in jsonArray {
                    let movie = MoviesList(movieJSON: movieJson)
                    movies.append(movie)
                }
                self.saveDataIntoRealm(movies: movies)
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.movieVC?.tableView.reloadData()
                }
                
            case .failure(let err):
                SVProgressHUD.dismiss()
                print("Error getting movie list: \(err.localizedDescription)")
            }
        }
        
    }
    

    //MARK:- Get movie detail
    func getMovieDetail(movieId:Int) {
        SVProgressHUD.show()
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)?api_key=\(Constants.apiKey)"
        AF.request(urlString, method: .get).responseJSON { (response) in
            switch response.result {
            case .success(let data):
                SVProgressHUD.dismiss()
                let jsonData:JSON = JSON(data)
                var geners:[String] = []
                let movieName = jsonData["title"].stringValue
                let date = jsonData["release_date"].stringValue
                let overView = jsonData["overview"].stringValue
                let movieId = jsonData["id"].intValue
                let moviePoster = jsonData["backdrop_path"].stringValue
                let genersArray = jsonData["genres"].arrayValue
                for data in genersArray {
                    let name = data["name"].stringValue
                    geners.append(name)
                }
                let joinedGeners = geners.joined(separator: ", ")
                
                let movieDetail = MovieDetail()
                movieDetail.movieName = movieName
                movieDetail.date = date
                movieDetail.overView = overView
                movieDetail.movieId = movieId
                movieDetail.moviePoster = moviePoster
                movieDetail.geners = joinedGeners
                
                self.saveMovieDetailInRealm(detail: movieDetail)
                DispatchQueue.main.async {
                    self.detailVC?.updateUI()
                }
            case .failure(let err):
                SVProgressHUD.dismiss()
                print("Error getting movie detail: \(err.localizedDescription)")
            }
        }
    }
    

    //MARK:- get movie trailer data
    func getTrailerData(movieId:Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=\(Constants.apiKey)"
        AF.request(urlString, method: .get).responseJSON { (response) in
            if let data = response.data {
                do {
                    let trailerResponse = try JSONDecoder().decode(TrailerModel.self, from: data)
                    self.arrayTrailerResult.append(contentsOf: trailerResponse.results!)
                } catch let err {
                    print("Error getting movie trailer data: \(err.localizedDescription)")
                }
            }
        }
    }
    
    
   //MARK:- Save movie list to realm database
    func saveDataIntoRealm(movies:[MoviesList]) {
        do {
            try realm.write{
                realm.add(movies, update: .all)
            }
        } catch let err {
            print("Error saving data in realm: \(err.localizedDescription)")
        }
    }
    

    //MARK:- Save movie detail in realm database
    func saveMovieDetailInRealm(detail:MovieDetail) {
        do {
            try realm.write{
                realm.add(detail, update: .all)
            }
        } catch let err {
            print("Error saving data in realm: \(err.localizedDescription)")
        }
    }
}
