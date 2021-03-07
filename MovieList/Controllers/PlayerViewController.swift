//
//  PlayerViewController.swift
//  MovieList
//
//  Created by Sohaib Siddique on 07/03/2021.
//

import UIKit
import youtube_ios_player_helper

class PlayerViewController: UIViewController {
    
    @IBOutlet weak var playerView: YTPlayerView!
    
    var videoId:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        playerView.load(withVideoId: videoId, playerVars: ["playsinline": 1])
    }

}

extension PlayerViewController: YTPlayerViewDelegate {
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        //  print(state)
    }
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        //  print(playTime)
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
        playerView.playVideo()
    }
}

