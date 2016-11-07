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
        id = data.object(forKey: "id") as! Int
        artist = (data.object(forKey: "user") as! NSDictionary).object(forKey: "username") as! String
        title = data.object(forKey: "title") as! String

        var originalSize: String!
        var largerSize: String!

        artworkURL = data.object(forKey: "artwork_url") as! String
        if artworkURL.characters.last! == "0" {
            originalSize = "80&height=80"
            largerSize = "500&height=500"
        } else {
            originalSize = "large.jpg"
            largerSize = "t500x500.jpg"
        }
        artworkURL = artworkURL.replacingOccurrences(of: originalSize, with: largerSize)
        canStream = data.object(forKey: "streamable") as! Bool
    }

    func getURL() -> URL {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let clientID = NSDictionary(contentsOfFile: path!)?.value(forKey: "client_id") as! String
        return URL(string: "https://api.soundcloud.com/tracks/\(self.id)/stream?client_id=\(clientID)")!
    }
}
