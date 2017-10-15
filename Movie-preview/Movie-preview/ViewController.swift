//
//  ViewController.swift
//  Movie-preview
//
//  Created by Yveslym on 10/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    var movie = Movie()
    @IBAction func search(_ sender: Any) {
        let mysearch = self.search.text
        //DispatchQueue.global().sync {
            Network.find_movie(movieName: mysearch!, completion: {movies in
                self.movie = movies!
                print(movies!)
                self.updateView()
            })
    }
    
            
            func updateView(){
                 DispatchQueue.main.sync {
                
                self.movieID.text = String(describing: self.movie.id)
                self.movieTitle.text = self.movie.title
                self.originTitle.text = self.movie.originalTitle
                self.overview.text = self.movie.overview
                self.releaseDate.text = self.movie.releaseDate
                self.vote.text = String(describing: self.movie.voteAverage)
                
                if self.movie.imageBaseLink != nil{
                    let url = URL(string: self.movie.imageBaseLink!)
                    if url != nil {
                        let data = try? Data(contentsOf: url!)
                        self.poster.image = UIImage(data: data!)
                    }
                }
                self.reloadInputViews()
            }
        }
    //}
    //}
    
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var originTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieID: UILabel!
    @IBOutlet weak var vote: UILabel!
    @IBOutlet weak var search: UISearchBar!
}

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}



