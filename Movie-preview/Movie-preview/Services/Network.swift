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
    //==>Mark
    /// function to save movie with user email as main key
    static func save_movie(movie: Movie){
        // make movie user = to current user
        
        ///set network url and url request
        let urlString = "http://127.0.0.1:5000/movies"
        guard let url = URL(string: urlString) else {return}
         let authHeaderString =  BasicAuth.generateBasicAuthHeader(username: currentUser.email, password: currentUser.password)
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(authHeaderString, forHTTPHeaderField: "Authorization")
        
        do{
            let jsonBody = try JSONEncoder().encode(movie)
            request.httpBody = jsonBody
        }catch{}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            guard let data = data else {return}
            do{
                 _ = try JSONEncoder().encode(data)
                
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    _ = (response as? HTTPURLResponse)?.textEncodingName
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    
                    if statusCode == 400 || statusCode == 401{
                        //let responseData = String(data: data!, encoding: String.Encoding.utf8)!
                        let errorMessage = try JSONDecoder().decode(Errors.self, from: data)
                        print (errorMessage.error)
                    }
                    
                }
                else {
                    // Failure
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    print (statusCode)
                    print("URL Session Task Failed: %@", error!.localizedDescription)
                }

            }
            catch{}
        }
        task.resume()
    }
    
    //==>Mark function to fetch movies from database

    static func fetcMovies(completion:@escaping(Movie?)->Void){
        
        let urlString = "http://127.0.0.1:5000/movies"
        guard let url = URL(string: urlString) else {return}
        let authHeaderString =  BasicAuth.generateBasicAuthHeader(username: currentUser.email, password: currentUser.password)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(authHeaderString, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            
            do{
                guard let data = data else {return}
                let mymovie = try JSONDecoder().decode(Movie.self, from: data)
                let statusCode = (response as! HTTPURLResponse).statusCode
                return completion(mymovie)
            }
            catch{}
        }
        task.resume()
    }
}

   


























