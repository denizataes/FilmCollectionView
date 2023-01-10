//
//  SearchViewController.swift
//  FilmCollectionView
//
//  Created by Deniz Ata Eş on 10.01.2023.
//

import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate {
    var searchList: [Movie]?
    let searchController = UISearchController()
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.stopAnimating()
        //MARK: SearchController
        navigationItem.searchController = searchController

        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = true
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        searchController.searchBar.delegate = self
        searchController.searchBar.setValue("İptal", forKey: "cancelButtonText")
        searchController.searchBar.placeholder = "Ara..."
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.barTintColor = .systemGreen
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "Ara 🎬"
        configure()
        
        collectionView?.contentInset = UIEdgeInsets(top: 12, left: 4, bottom: 12, right: 4)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.configure()
        }
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

}

extension SearchViewController: UICollectionViewDataSource
{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = searchList {
            return posts.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = self.searchList?[indexPath.row]

        cell.imageView.kf.setImage(with: URL(string: "\(Constants.imageURL)\(movie?.posterPath ?? "")")) { result in
            switch result {
            case .success(let value):
                let averageColor = value.image.averageColor
                let opaqueColor = averageColor?.withAlphaComponent(0.7)
                cell.contentView.backgroundColor = opaqueColor
            case .failure(let error):
                print("Error: \(error)")
            }
        }
        cell.overviewLabel.text = movie?.overview ?? ""
        cell.titleLabel.text = movie?.title ?? ""
        cell.releaseDateLabel.text = Helper.shared.convertDate(dateString: movie?.releaseDate)
        return cell
    }
}

extension SearchViewController : PinterestLayoutDelegate
{
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        return 280
    }

    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        var height: CGFloat = 0
        if let post = searchList?[indexPath.item] {
                let topPadding = CGFloat(12)
                let bottomPadding = CGFloat(12)
                let captionFont = UIFont.systemFont(ofSize: 10)
                let captionHeight = Helper.shared.height(for: post.overview!, with: captionFont, width: width)
                height = topPadding + captionHeight + topPadding  + bottomPadding + captionHeight + 4
            return height
        }

        return 0.0
    }


}

extension SearchViewController: UISearchBarDelegate, UISearchResultsUpdating{
    ///If searchController textfield change then search by query.
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            if searchText.count == 0 {
                searchList = nil
                collectionView.reloadData()
            }
            guard searchText.count > 2 else {return}
            activityIndicator.startAnimating()
            searchByQuery(query: searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
            collectionView.collectionViewLayout.invalidateLayout()
        }
    
    
    func updateSearchResults(for searchController: UISearchController) {}
    
    
    private func searchByQuery(query: String){
        
        APICaller.shared.search(with: query) { data in
            switch(data)
            {
            case .success(let searchList):
                DispatchQueue.main.async {
                    self.searchList = searchList
                    self.collectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.activityIndicator.stopAnimating()
            }
        }
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchList?.removeAll()
        self.collectionView.reloadData()
    }
}

















