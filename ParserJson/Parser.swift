//
//  Parser.swift
//  ParserJson
//
//  Created by Valerio Ferrucci on 11/11/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

import Foundation

/*
// uncomment this when apple fix bug http://coding.tabasoft.it/ios/a-compiler-crash/:
// and use JSONDecodable instead of Photo here
protocol JSONDecodable {
    class func decode(json: [String: AnyObject]) -> Self?
}
*/

func StringFromJSON(ao : AnyObject) -> String? {
    return ao as? String
}
func DoubleFromJSON(ao : AnyObject) -> Double? {
    return ao as? Double
}
func DictionaryFromJSON(ao : AnyObject) -> [String: AnyObject]? {
    return ao as? [String: AnyObject]
}

class Parser {

    //MARK: PUBLIC (internal)
    enum ParserError : Int {
        case ReadingData = 100
        case ConvertingMainJsonObj
        case ConvertingAnElement
    }
    
    enum ReaderResult {
        case Value(NSData)
        case Error(NSError)
    }
    
    enum Result {
        case Value(Photo)
        case Error(NSError)
    }

    // the reader is a func that receive a completion as parameter (called on finish)
    typealias ParserReader = (ReaderResult->())->()
    typealias ParserCallback = (Result)->Bool
    
    func start(reader : ParserReader, parserCallback : ParserCallback) {
        
        var error : NSError?
        
        // read the file
        reader() { (result : ReaderResult)->() in
            
            switch result {
            case let .Error(readError):
                error = readError
                
            case let .Value(fileData):
                error = self.handleData(fileData, parserCallback)
            }
            
            if let _error = error {
                let parseError = NSError(domain: "Parser", code: ParserError.ReadingData.rawValue, userInfo: [NSLocalizedDescriptionKey: "Error reading data", NSUnderlyingErrorKey: _error])
                parserCallback(Parser.Result.Error(_error))
            }
        }
    }
    
    //MARK: PRIVATE
   
    private func handleData(data : NSData, parserCallback : ParserCallback) -> NSError? {
        
        var error : NSError?
        let json : AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: &error)
        
        if let _json = json as? [AnyObject] {
            
            for jsonItem in _json {
                
                if let _jsonItem = jsonItem >>> DictionaryFromJSON {
                    
                    let element = Photo.decode(_jsonItem)
                    if let _element = element {
                        let toStop = parserCallback(Result.Value(_element))
                        if toStop {
                            break
                        }
                    } else {
                        // don't override error
                        let elementError = NSError(domain: "Parser", code: ParserError.ConvertingAnElement.rawValue, userInfo: [NSLocalizedDescriptionKey:"Errore su un elemento dell'array"])
                        let toStop = parserCallback(Result.Error(elementError))
                        if toStop {
                            break
                        }
                    }
                }
            }
        } else {
            error = NSError(domain: "Parser", code: ParserError.ConvertingMainJsonObj.rawValue, userInfo: [NSLocalizedDescriptionKey:"Json is not an array of AnyObjects"])
        }
        
        return error
    }
}