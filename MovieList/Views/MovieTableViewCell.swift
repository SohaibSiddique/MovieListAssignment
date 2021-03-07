//
//  MovieTableViewCell.swift
//  MovieList
//
//  Created by Sohaib Siddique on 06/03/2021.
//

import UIKit

class MovieTableViewCell: UITableViewCell {


    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    static let cellIdentifier:String = "MovieTableViewCell"
    
    var movieModel:MoviesList? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static func nib() -> UINib {
        return UINib(nibName: cellIdentifier, bundle: nil)
    }
    
    func configure() {
        let imageUrl = Constants.baseUrlImage + (movieModel?.moviePoster ?? "")
        Helper.sharedInstance.imageLoading(imageView: imageview, url: imageUrl)
        lblTitle.text = movieModel?.movieName ?? ""
        
    }
    
}
