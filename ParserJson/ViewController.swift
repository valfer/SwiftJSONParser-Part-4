//
//  ViewController.swift
//  ParserJson
//
//  Created by Valerio Ferrucci on 05/11/14.
//  Copyright (c) 2014 Valerio Ferrucci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parser = Parser()
        let parserTestReader = readJsonFile("test")
        // uncomment this (and comment above) to get the json data from the web
        // let parserTestReader = getJsonFromWeb("http://www.tabasoft.it/ios/json/photos.json")
        parser.start(parserTestReader) { (parserResult : Parser.Result) -> Bool in
            
            switch parserResult {
            case let .Error(error):
                println("Parser Error \(error.code): " + error.localizedDescription)
        
            case let .Value(element):
                // uncomment "as Photo" this when using JSONDecodable 
                let photo = element     // as Photo
                println(photo.data + ": " + photo.titolo)
                
            }
            
            return false    // continue always (if possible)
        }
    }

    private func readJsonFile(jsonFileName : String)(completion : Parser.ReaderResult->()) {
        
        var fileData : NSData?
        var error : NSError?
        let filePath : String? = NSBundle.mainBundle().pathForResource(jsonFileName, ofType: "json")
        
        if let _filePath = filePath {
            
            fileData = NSData(contentsOfFile: _filePath, options:.DataReadingUncached, error: &error)
        
        } else {
            
            error = NSError(domain: "ParserReader", code: 100, userInfo: [NSLocalizedDescriptionKey:"The file was not found"]);
        }
        
        var result : Parser.ReaderResult
        if (error != nil) {
            result = Parser.ReaderResult.Error(error!)
        } else {
            result = Parser.ReaderResult.Value(fileData!)
        }
        completion(result)
    }
    
    private func getJsonFromWeb(jsonUrl : String)(completion : Parser.ReaderResult->()) {
        
        var fileData : NSData?
        var error : NSError?
        let url = NSURL(string: jsonUrl);
        if let _url = url {
            var request = NSURLRequest(URL: NSURL(string: jsonUrl)!)
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, urlResponse, error in
                
                var result : Parser.ReaderResult
                if (error != nil) {
                    result = Parser.ReaderResult.Error(error!)
                } else {
                    result = Parser.ReaderResult.Value(data!)
                }
                completion(result)
            }
            task.resume()
        
        } else {
            error = NSError(domain: "ParserReader", code: 101, userInfo: [NSLocalizedDescriptionKey:"Wrong URL"]);
            completion(Parser.ReaderResult.Error(error!))
        }
    }
}

