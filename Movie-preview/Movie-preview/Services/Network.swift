//
//  Network.swift
//  Movie-preview
//
//  Created by Yveslym on 10/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

class Network{
    
    ///function to parse movie from themoviedb api
   static func find_movie(movieName:String) {
        
        var url = URL(string: "https://api.themoviedb.org/3/search/movie")
        let URLParams = [
            "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
            "query": movieName,
            "page": "1",
            ]
    
        url = url?.appendingQueryParameters(URLParams)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    let session = URLSession.shared
    let task = session.dataTask(with: request){data,response,error in
        
        
        do{
            guard let data = data else {return}
            let mymovie = try JSONDecoder().decode(Movie.self, from: data)
            let statusCode = (response as! HTTPURLResponse).statusCode
          
            print("URL Session Task Succeeded: HTTP \(statusCode)")
            print (mymovie)
        }
        catch{}
    }
    task.resume()
    }
    
    static func save_movie(movie: Movie){
        // make movie user = to current user
        let urlString = "http://127.0.0.1:5000/movies"
        guard let url = URL(string: urlString) else {return}
        
        var request = URLRequest(url: url)
        
        
    }
    
    struct BasicAuth {
        static func generateBasicAuthHeader(username: String, password: String) -> String {
            let loginString = String(format: "%@:%@", username, password)
            let loginData: Data = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString(options: .init(rawValue: 0))
            let authHeaderString = "Basic \(base64LoginString)"
            
            return authHeaderString
        }
    }
}


























