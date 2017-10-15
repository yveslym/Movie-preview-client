//
//  Movie&User.swift
//  Movie-preview
//
//  Created by Yveslym on 10/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

struct Movie: Codable{
    var title : String
    var id :Int
    var overview: String
    var originalTitle: String
    var releaseDate: String
    var posterPath: String
    var user: String
    
    
    enum CodingKeys:String,CodingKey {
        case results
        
        enum Results:String,CodingKey {
            case title
            case id
            case overview
            case originalTile = "original_title"
            case releaseDate = "release_date"
            case posterPath = "poster_path"
            case user
        }
    }
    init(from decoder: Decoder)throws {
        
        
         let contenaire = try decoder.container(keyedBy:CodingKeys.self)
         var ContenaireResults = try contenaire.nestedUnkeyedContainer(forKey: .results)
         let results = try ContenaireResults.nestedContainer(keyedBy: CodingKeys.Results.self)
         id = (try results.decodeIfPresent(Int.self, forKey: .id)!)
         user = (try results.decodeIfPresent(String.self, forKey: .user)!)
         title = (try results.decodeIfPresent(String.self, forKey: .title)!)
         overview = (try results.decodeIfPresent(String.self, forKey: .overview)!)
          posterPath = (try results.decodeIfPresent(String.self, forKey: .posterPath)!)
         releaseDate = (try results.decodeIfPresent(String.self, forKey: .releaseDate)!)
         originalTitle = (try results.decodeIfPresent(String.self, forKey: .originalTile)!)
        
        
        
    }
    
    func encode(to encoder: Encoder) throws {
        var contenaire =  encoder.container(keyedBy: CodingKeys.self)
        var contenaireResult = contenaire.nestedUnkeyedContainer(forKey: .results)
        var results = contenaireResult.nestedContainer(keyedBy: CodingKeys.Results.self)
        try results.encode(id, forKey: .id)
        try results.encode(title,forKey: .title)
        try results.encode(overview,forKey: .overview)
        try results.encode(releaseDate,forKey: .releaseDate)
        try results.encode(originalTitle,forKey: .originalTile)
        try results.encode(posterPath, forKey: .posterPath)
        try results.encode(user, forKey: .user)
    }
}

extension Movie{
    static func decodeMovie ()->[Movie]{
        if currentUser != nil{
        //fetch movie from database
        }
}

class Users: Codable{
    
    var firstName: String
    var lastName: String
    let email: String
    let password: String
    var favoriteMovie: [Movie]
    var userName: String
    
    enum codingKeys: String,CodingKey {
        case first_name
        case last_name
        case email
        case user_name
        case Password
    }
    
    required init(from decoder: Decoder)throws {
        let contenaire = try decoder.container(keyedBy: codingKeys.self)
        self.firstName = (try contenaire.decodeIfPresent(String.self, forKey: .first_name)!)
        self.lastName = (try contenaire.decodeIfPresent(String.self, forKey: .last_name)!)
        self.email =  (try contenaire.decodeIfPresent(String.self, forKey: .email)!)
        self.userName =  (try contenaire.decodeIfPresent(String.self, forKey: .user_name)!)
        self.password = ""
        Network.fetcMovies(completion: {movie in
            self.favoriteMovie.append(movie!)
        })
    }
}
}

struct Errors: Decodable{
    var error:String
    
    enum errorKey:String, CodingKey {
        case error
    }
    init(from decoder:Decoder)throws {
        let contenaire = try decoder.container(keyedBy: errorKey.self)
        error = (try contenaire.decodeIfPresent(String.self, forKey: .error))!
    }
}






















