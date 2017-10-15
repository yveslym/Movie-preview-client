//
//  Network.swift
//  Movie-preview
//
//  Created by Yveslym on 10/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

class Network{
    
   static func find_movie(movieName:String) {
        
        var url = URL(string: "https://api.themoviedb.org/3/search/movie")
        let URLParams = [
            "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
            "query": movieName,
            "page": "1",
            
            ]
        //url?.appendingQueryParameters(URLParams)
        url = url?.appendingQueryParameters(URLParams)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    let session = URLSession.shared
    let task = session.dataTask(with: request){data,response,error in
        
        guard let data = data else {return}
        do{
            let mymovie = try JSONDecoder().decode(Movie.self, from: data)
            print (mymovie.title)
            
//            print(error)
//
//            print(response)
        }
        catch{}
    }
    task.resume()

        
    }
    
    
}
