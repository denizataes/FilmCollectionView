//
//  TopRatedViewController.swift
//  FilmCollectionView
//
//  Created by Deniz Ata Eş on 9.01.2023.
//

import UIKit

class TopRatedViewController: UIViewController {
    
    var trendingMovieList = [Movie]()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        

        }
    
    private func configure() {
        APICaller.shared.getTrendingMovies { result in
            switch result {
            case .success(let titles):
                self.trendingMovieList = titles
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
