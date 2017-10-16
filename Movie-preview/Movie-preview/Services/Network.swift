//
//  Network.swift
//  Movie-preview
//
//  Created by Yveslym on 10/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

class Network{
    
    static func create_user(users:Users!){
        
        let urlString = "http://127.0.0.1:5000/users"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        
        do{
            //try users.encode(to: JSONEncoder() as! Encoder)
            let jsonBody = try JSONEncoder().encode(users)
            request.httpBody = jsonBody
        }catch{}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){(data,response,error) in
            
            guard let data = data else {return}
            
            do{
                _ = try JSONSerialization.jsonObject(with: data, options: [])
            }catch{}
            
            if (error == nil) {
                // Success
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                print(response?.description as Any)
            }
            else {
                // Failure
                let statusCode = (response as! HTTPURLResponse).statusCode
                print (statusCode)
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        }
        task.resume()
    }
    
    
    // function to get user from the database by the auth token
    static func fetch_user(email: String, password: String){
        
        // get the auth header
        let authHeaderString =  BasicAuth.generateBasicAuthHeader(username: email, password: password)
        
        let urlString = "http://127.0.0.1:5000/users"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(authHeaderString, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){(data,response,error) in
            
            guard let data = data else {return}
            
            do{
                let user = try JSONDecoder().decode(Users.self, from: data)
                print (user)
            }
            catch{}
        }
        task.resume()
    }
    
    ///function to delete user by with the auth token
    static func deleteUser(email:String, password: String){
        
        let authHeaderString = BasicAuth.generateBasicAuthHeader(username: email, password: password)
        
        let urlString = "http://127.0.0.1:5000/users"
        guard let url = URL(string: urlString) else {return}
        var request = URLRequest(url: url)
        
        request.httpMethod = "DELETE"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(authHeaderString, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){(data,response,error)in
            do{
                if (error == nil) {
                    // Success
                    let statusCode = (response as! HTTPURLResponse).statusCode
                    _ = (response as? HTTPURLResponse)?.textEncodingName
                    print("URL Session Task Succeeded: HTTP \(statusCode)")
                    
                    if statusCode == 400 || statusCode == 401{
                        //let responseData = String(data: data!, encoding: String.Encoding.utf8)!
                        let errorMessage = try JSONDecoder().decode(Errors.self, from: data!)
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
            catch {}
        }
        task.resume()
    }
    


    
    
    
    
    
    
    ///function to parse movie from themoviedb api
    static func find_movie(movieName:String, completion: @escaping(search_result?)->Void) {
        
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
            let mymovie = try JSONDecoder().decode(search_result.self, from: data)
            let statusCode = (response as! HTTPURLResponse).statusCode
          
            print("URL Session Task Succeeded: HTTP \(statusCode)")
            print (mymovie)
            
            return completion(mymovie)
        }
        catch{}
    }
    task.resume()
    }
    
    
    //==>Mark  function to save movie with user email as main key
    static func save_movie(movie: Movie){
        // make movie user = to current user
        
        
        ///set network url and url request
        let urlString = "http://127.0.0.1:5000/movies"
        guard let url = URL(string: urlString) else {return}
        let authHeaderString =  BasicAuth.generateBasicAuthHeader(username: (Users.currentUser?.email)!, password: (Users.currentUser?.password)!)
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
            }
            catch{}
        }
        task.resume()
    }
    
    //==> function to fetch movie link through youtube api
    
    func findVideoLink(title: String, completion:@escaping(URL?)->Void){
        
        //let baseURL = "https://www.youtube.com/watch?v="
        let link = "https://www.googleapis.com/youtube/v3/search"
        guard var url = URL(string: link) else {return}
        
        let searchName = title+" "+" trailer"
        
        // set-up url parameter
        let urlParam = ["part":"snippet",
                        "maxResults":"1",
                        "order":"relevance",
                        "q":searchName,
                        "type":"video",
                        "videoDefinition":"high",
                        "videoDuration":"short",
                        "videoEmbeddable":"true",
                        "key":"AIzaSyB0iNNQahMNATrr1p-pxC4kre55FZJ20hg"]
        url = url.appendingQueryParameters(urlParam)
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "forHTTPHeaderField: Content-Type")
        
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            
            
            do{
                guard let data = data else {return}
                let movieLink = try JSONDecoder().decode(VideoLink.self, from: data)
                let statusCode = (response as! HTTPURLResponse).statusCode
                
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                print (movieLink)
                
                //return completion(mymovie)
            }
            catch{}
        }
        task.resume()
    }
    
    
    //==>Mark function to fetch movies from database

    static func fetcMovies(completion:@escaping(Movie?)->Void){
        
        let urlString = "http://127.0.0.1:5000/movies"
        guard let url = URL(string: urlString) else {return}
        let authHeaderString =  BasicAuth.generateBasicAuthHeader(username: (Users.currentUser?.email)!, password: (Users.currentUser?.password)!)
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue(authHeaderString, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            
            do{
                guard let data = data else {return}
                let mymovie = try JSONDecoder().decode(Movie.self, from: data)
                _ = (response as! HTTPURLResponse).statusCode
                return completion(mymovie)
            }
            catch{}
        }
        task.resume()
    }
    
    static func delete_movie(movie: Movie){
        
        let urlString = "http://127.0.0.1:5000/movies"
        guard var url = URL(string: urlString) else {return}
        let urlparam = ["movie_id": String(movie.id)]
        
        url = url.appendingQueryParameters(urlparam)
        
        let authHeaderString =  BasicAuth.generateBasicAuthHeader(username: (Users.currentUser?.email)!, password: (Users.currentUser?.password)!)
        var request = URLRequest(url: url)
        request.httpMethod = "Delete"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.setValue(authHeaderString, forHTTPHeaderField: "Authorization")
        
        do{
        let jsonBody = try JSONEncoder().encode(movie)
        request.httpBody = jsonBody
       
        }catch{}
        
        let session = URLSession.shared
        let task = session.dataTask(with: request){data,response,error in
            do{
                let statusCode = (response as! HTTPURLResponse).statusCode
                if statusCode == 200{
                    var index = 0
                    for mov in (Users.currentUser?.favoriteMovie)!{
                        if mov.id == movie.id{
                            Users.currentUser?.favoriteMovie.remove(at: index)
                            index = index+1
                        }
                        
                    }
                }
                
            } catch{}
        
        }
        task.resume()
    }
    
}

   


























