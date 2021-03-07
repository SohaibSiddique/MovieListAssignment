//
//  ViewController.swift
//  MovieList
//
//  Created by Sohaib Siddique on 06/03/2021.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBarBottomConstraint: NSLayoutConstraint!
    
    var movieViewModel = MovieViewModel()
    private var pageNo:Int = 1
    var isSearchEnable:Bool = false
    let realm = try! Realm()
    var movieList:Results<MoviesList>? = nil
    var filterArray: Results<MoviesList>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieViewModel.movieVC = self
        searchBar.delegate = self
        setupDesignElements()
        setupTableView()
        getData()
        movieList = realm.objects(MoviesList.self)
        //print(Realm.Configuration.defaultConfiguration.fileURL!) // for getting realm file url
    }

    func setupDesignElements() {
        self.title = "Movie Catalog"
        searchBar.placeholder = "e.g Iron Man"
        searchBar.showsCancelButton = false
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //get keyboard height
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            var keyboardHeight:CGFloat = 0
            if #available(iOS 11.0, *) {
                keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
            } else {
                keyboardHeight = keyboardFrame.cgRectValue.height
            }
            searchBarBottomConstraint.constant = keyboardHeight
        }
    }
    
    //Setup tableview cells, datasource and delegate
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.cellIdentifier)
    }
    
    //Api Call for movie list
    func getData() {
        movieViewModel.getMovies(pageNo: self.pageNo)
    }
    
    func goToDetailView(movieId:Int, movieName:String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.movieId = movieId
        detailVC.movieName = movieName
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK:- TableView Datasource and Delegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchEnable {
            return filterArray?.count ?? 0
        } else {
            return movieList?.count ?? 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.cellIdentifier, for: indexPath) as! MovieTableViewCell
        cell.selectionStyle = .none
        if isSearchEnable {
            cell.movieModel = filterArray![indexPath.row]
        } else {
            cell.movieModel = movieList![indexPath.row]
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieId = movieList?[indexPath.row].movieId ?? 0
        let movieName = movieList?[indexPath.row].movieName ?? ""
        self.goToDetailView(movieId: movieId, movieName: movieName)
    }
    
    //Handle Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if isSearchEnable == false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if tableView.visibleCells.contains(cell) {
                    let totalResults = self.movieViewModel.totalResult
                    let arrayCount = self.movieList?.count ?? 0
                    if indexPath.row == arrayCount - 1 && arrayCount < totalResults {
                        self.pageNo += 1
                        self.movieViewModel.getMovies(pageNo: self.pageNo)
                    }
                }
            }
        }
    }
}

//MARK:- Search Controller
extension ViewController: UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBarBottomConstraint.constant = 0
        isSearchEnable = true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.filterArray = self.movieList
        searchBar.showsCancelButton = true
        isSearchEnable = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        isSearchEnable = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBarBottomConstraint.constant = 0
        isSearchEnable = false
        self.tableView.reloadData()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterArray = self.movieList!.filter("(movieName CONTAINS[cd] %@)", searchText)
        
        tableView.reloadData()
    }
        
}
