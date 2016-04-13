//
//  Track.swift
//  Play
//
//  Created by Gene Yoo on 11/28/15.
//  Copyright © 2015 cs198-1. All rights reserved.
//

import Foundation

class Track {
    var id: Int!
    var title: String!
    var artist: String!
    var artworkURL: String!
    var canStream: Bool!
    
    init (data: NSDictionary) {
        id = data.objectForKey("id") as! Int
        artist = data.objectForKey("user")?.objectForKey("username") as! String
        title = data.objectForKey("title") as! String
        
        var originalSize: String!
        var largerSize: String!
        
        artworkURL = data.objectForKey("artwork_url") as! String
        if artworkURL.characters.last! == "0" {
            originalSize = "80&height=80"
            largerSize = "500&height=500"
        } else {
            originalSize = "large.jpg"
            largerSize = "t500x500.jpg"
        }
        artworkURL = artworkURL.stringByReplacingOccurrencesOfString(originalSize, withString: largerSize)
        canStream = data.objectForKey("streamable") as! Bool
    }

    func getURL() -> NSURL {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let clientID = NSDictionary(contentsOfFile: path!)?.valueForKey("client_id") as! String
        return NSURL(string: "https://api.soundcloud.com/tracks/\(self.id)/stream?client_id=\(clientID)")!
    }
}