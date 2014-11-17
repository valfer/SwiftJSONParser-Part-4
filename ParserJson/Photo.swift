//
//  Photo.swift
//  ParserJson
//
//  Created by Valerio Ferrucci on 05/11/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

// uncomment protocol when using JSONDecodable (waiting Apple bug fix)
struct Photo /*: JSONDecodable*/ {
    
    let titolo : String
    let autore : String
    let latitudine : Double
    let longitudine : Double
    let data : String
    let descr : String
    
    static func create(titolo : String)(autore : String)(latitudine : Double)(longitudine : Double)(data : String)(descr : String) -> Photo {
        return Photo(titolo: titolo, autore: autore, latitudine: latitudine, longitudine: longitudine, data: data, descr: descr)
    }
    
    static func decode(json : [String: AnyObject]) -> Photo? {
        
        let photo = Photo.create <^>
            json["titolo"] >>> StringFromJSON <*>
            json["autore"] >>> StringFromJSON <*>
            json["latitudine"] >>> DoubleFromJSON <*>
            json["longitudine"] >>> DoubleFromJSON <*>
            json["data"] >>> StringFromJSON <*>
            json["descr"] >>> StringFromJSON
        
        return photo
    }
}