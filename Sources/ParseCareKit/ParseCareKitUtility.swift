//
//  ParseCareKitUtility.swift
//  ParseCareKit
//
//  Created by Corey Baker on 4/26/20.
//  Copyright © 2020 Network Reconnaissance Lab. All rights reserved.
//

import Foundation
import ParseSwift

public struct ParseCareKitUtility {
    
    public static func setupServer() {
        var propertyListFormat =  PropertyListSerialization.PropertyListFormat.xml
        var plistConfiguration:[String: AnyObject]
        guard let path = Bundle.main.path(forResource: "ParseCareKit", ofType: "plist"),
            let xml = FileManager.default.contents(atPath: path) else{
                fatalError("Error in ParseCareKit.setupServer(). Can't find ParseCareKit.plist in this project")
        }
        
        do{
            plistConfiguration = try PropertyListSerialization.propertyList(from: xml, options: .mutableContainersAndLeaves, format: &propertyListFormat) as! [String:AnyObject]
        }catch{
            fatalError("Error in ParseCareKit.setupServer(). Couldn't serialize plist. \(error)")
        }
        
        guard let parseDictionary = plistConfiguration["ParseClientConfiguration"] as? [String:AnyObject],
            let appID = parseDictionary["ApplicationID"] as? String,
            let server = parseDictionary["Server"] as? String,
            let serverURL = URL(string: server),
            let _ = parseDictionary["EnableLocalDataStore"] as? Bool else {
                fatalError("Error in ParseCareKit.setupServer(). Missing keys in \(plistConfiguration)")
        }
        
        ParseSwift.initialize(applicationId: appID, serverURL: serverURL)
    }
    
    public static func dateToString(_ date:Date)->String{
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        return dateFormatter.string(from: date)
    }
    
    public static func stringToDate(_ date:String)->Date?{
        let dateFormatter:DateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        
        return dateFormatter.date(from: date)
    }
    
    public static func encoder() -> ParseEncoder {
        Note().getEncoder()
    }

    public static func jsonEncoder() -> JSONEncoder {
        Note().getJSONEncoder()
    }
    
    public static func decoder() -> JSONDecoder {
        Note().getDecoder()
    }
}
