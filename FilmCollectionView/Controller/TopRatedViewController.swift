//
//  TopRatedViewController.swift
//  FilmCollectionView
//
//  Created by Deniz Ata Eş on 9.01.2023.
//

import AVKit
import AVFoundation
import UIKit
import Kingfisher
class TopRatedViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var topRatedList: [Movie]?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        navigationController?.navigationBar.barTintColor = .systemBrown
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.topItem?.title = "En Beğenilenler 💯"
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
        APICaller.shared.getTopRated { result in
            switch result {
            case .success(let titles):
                self.topRatedList = titles
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                   // self.activityIndicator.stopAnimating()
                }

            case .failure(let error):
               // self.activityIndicator.stopAnimating()
                print(error.localizedDescription)
            }
        }
    }


}
//MovieCollectionViewCell
//
extension TopRatedViewController: UICollectionViewDataSource
{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let posts = topRatedList {
            return posts.count
        } else {
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        let movie = self.topRatedList?[indexPath.row]
        cell.imageView.image = UIImage(named: movie?.posterPath ?? "")
        cell.imageView.kf.setImage(with: URL(string: "\(Constants.imageURL)\(movie?.posterPath ?? "")"),placeholder: nil,options: [.transition(.fade(0.7))])
        
//        cell.durationLabel.text = String(movie?.runtime ?? 0)
        cell.overviewLabel.text = movie?.overview ?? ""
        cell.titleLabel.text = movie?.title ?? ""
        cell.releaseDateLabel.text = movie?.releaseDate ?? ""
        return cell
    }
}

extension TopRatedViewController : PinterestLayoutDelegate
{
    func collectionView(collectionView: UICollectionView, heightForPhotoAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let post = self.topRatedList?[indexPath.item], let photoURL = UIImage(named: "avatar") {
           // var imageView = UIImageView()
            //imageView.kf.setImage(with: photoURL)
            let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
            let rect = AVMakeRect(aspectRatio: photoURL.size, insideRect: boundingRect)

            return rect.size.height
        }

        return 0
    }

    func collectionView(collectionView: UICollectionView, heightForCaptionAt indexPath: IndexPath, with width: CGFloat) -> CGFloat
    {
        if let post = topRatedList?[indexPath.item] {
            let topPadding = CGFloat(12)
            let bottomPadding = CGFloat(12)
            let captionFont = UIFont.systemFont(ofSize: 10)
            let captionHeight = self.height(for: post.overview!, with: captionFont, width: width)
            let height = topPadding + captionHeight + topPadding  + bottomPadding + 80

            return height
        }

        return 0.0
    }

    func height(for text: String, with font: UIFont, width: CGFloat) -> CGFloat
    {
        let nsstring = NSString(string: text)
        let maxHeight = CGFloat(MAXFLOAT)//değiştirirsen maximumu artar
        let textAttributes = [NSAttributedString.Key.font : font]
        let boundingRect = nsstring.boundingRect(with: CGSize(width: width, height: maxHeight), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil)
        return ceil(boundingRect.height)
    }
}















