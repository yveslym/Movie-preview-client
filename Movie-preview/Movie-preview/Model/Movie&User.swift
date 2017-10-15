//
//  Movie&User.swift
//  Movie-preview
//
//  Created by Yveslym on 10/14/17.
//  Copyright © 2017 Yveslym. All rights reserved.
//

import Foundation

struct Movie: Decodable{
    var title : String
       var id :Int
    //    var overview: String
    //    var originalTitle: String
    //    var releaseDate: String
    
    enum CodingKeys:String,CodingKey {
        case results
        
        enum Results:String,CodingKey {
            case title
                       case id
            //            case overview
            //            case originalTile = "original_title"
            //            case releaseDate = "release_date"
        }
    }
    init(from decoder: Decoder)throws {
        
        
        let contenaire = try decoder.container(keyedBy:CodingKeys.self)
        var ContenaireResults = try contenaire.nestedUnkeyedContainer(forKey: .results)
        let results = try ContenaireResults.nestedContainer(keyedBy: CodingKeys.Results.self)
               id = (try results.decodeIfPresent(Int.self, forKey: .id)!)
        title = (try results.decodeIfPresent(String.self, forKey: .title)!)
        //        overview = (try results.decodeIfPresent(String.self, forKey: .overview)!)
        //        releaseDate = (try results.decodeIfPresent(String.self, forKey: .releaseDate)!)
        //        originalTitle = (try results.decodeIfPresent(String.self, forKey: .originalTile)!)
    }
}
