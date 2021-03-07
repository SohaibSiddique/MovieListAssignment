//
//  DetailViewController.swift
//  MovieList
//
//  Created by Sohaib Siddique on 06/03/2021.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGeners: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    var movieId:Int = 0
    var movieName:String = ""
    var movieViewModel = MovieViewModel()
    let realm = try! Realm()
    var movieDetail:Results<MovieDetail>? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        print(movieId)
        movieViewModel.detailVC = self
        setupDesignElements()
        getData()
        movieDetail = realm.objects(MovieDetail.self)
    }
    
    //Update design elements here
    func setupDesignElements() {
        self.title = "Movie Detail"
    }
    
    func getData() {
        movieViewModel.getMovieDetail(movieId: self.movieId)
        movieViewModel.getTrailerData(movieId: self.movieId)
    }
    
    //Update UI after successfull response from server
    func updateUI() {
        let result = movieDetail?.filter("movieId == \(movieId)")
        let data = result?[0]
        let imageUrl = Constants.baseUrlImage + (data?.moviePoster ?? "")
        Helper.sharedInstance.imageLoading(imageView: imageView, url: imageUrl)
        lblTitle.text = data?.movieName ?? ""
        lblGeners.text = data?.geners ?? ""
        if data?.date == "" {
            lblDate.text = "No Dates Available"
        } else {
            if let dateString = data?.date {
                lblDate.text = Helper.sharedInstance.formetDate(dateString)
            }
        }
        lblOverview.text = data?.overView ?? ""
    }
    
    //Go to youtube video player
    func goToPlayerView() {
        if let videoKey = movieViewModel.arrayTrailerResult[0].key {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let playerVC = storyBoard.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
            playerVC.videoId = videoKey
            self.navigationController?.pushViewController(playerVC, animated: true)
        }
    }
    
    //MARK:- Watch Trailer Button Action
    @IBAction func trailerBtnPressed(_ sender: UIButton) {
        goToPlayerView()
    }
}
