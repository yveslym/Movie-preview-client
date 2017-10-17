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
        
        if myResult != nil{
            if myResult?.results?.count != 0 {
                DispatchQueue.main.async {
                    let total = self.myResult?.results?.count
                    self.total?.text = String (total!)
                    self.counter.text = String(self.index+1)
                    self.movie = (self.myResult?.results![self.index])!
                    self.movieID.text = String(describing: self.movie.id)
                    self.movieTitle.text = self.movie.title
                    self.originTitle.text = self.movie.originalTitle
                    self.overview.text = self.movie.overview
                    self.releaseDate.text = self.movie.releaseDate
                    self.vote.text = String(describing: self.movie.voteAverage)
                    
                    let url = URL(string: self.movie.imageBaseLink)
                    if url != nil {
                        let data = try? Data(contentsOf: url!)
                        if data != nil{
                            self.poster.image = UIImage(data: data!)
                        }
                        else{
                            self.poster.image = UIImage(named: "icons8-anti_trump")
                        }
                    }
                    //  self.reloadInputViews()
                }
            }
        }
    }
    
    var movie = Movie()
    @IBAction func search(_ sender: Any) {
        
        let mysearch = self.search.text
        //DispatchQueue.global().sync {
        Network.find_movie(movieName: mysearch!, completion: {results in
            self.myResult = results
            self.index = 0
            //print(movies!)
            self.viewDidLoad()
        })
    }
    
    var myResult: search_result?
    var index = 0
    @IBOutlet weak var overview: UITextView!
    @IBOutlet weak var poster: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var originTitle: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieID: UILabel!
    @IBOutlet weak var vote: UILabel!
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var total: UILabel!
    
    // function to show up the next movie
    @IBAction func next(_ sender: Any) {
        if index < ((myResult?.results?.count)! - 1){
            index = index+1
            self.viewDidLoad()
        }
        else{
            index = 0
            self.viewDidLoad()
        }
        
    }
    // function to show up the previous movie
    @IBAction func previous(_ sender: Any) {
        if index > 0 && index < (myResult?.results?.count)!{
            index = index-1
            
            
            self.viewDidLoad()
        }
        else if index == 0{
            index = (myResult?.results?.count)! - 1
            
            self.viewDidLoad()
        }
        
    }
    
    @IBAction func trailer(_ sender:Any){
        
        Network.findVideoLink(title: self.movie.originalTitle, completion: {link in
            
        })
       
    }
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



