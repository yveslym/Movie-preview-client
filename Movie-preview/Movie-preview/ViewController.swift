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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var movie = Movie()
    @IBAction func search(_ sender: Any) {
        Network.find_movie(movieName: search.text!, completion: {movies in
            self.movie = movies!
            print(movies!)
            
             self.reloadInputViews()
        })
        
        self.movieID.text = String(describing: movie.id)
        self.movieTitle.text = movie.title
        self.originTitle.text = movie.originalTitle
        self.overview.text = movie.overview
        self.releaseDate.text = movie.releaseDate
        self.vote.text = String(describing: movie.voteAverage)
        self.poster.downloadedFrom(link: (movie.posterPath))
//        dispatch_sync(dispatch_get_main_queue(){
//            /* Do UI work here */
//            });
       
    }
    
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



