//
//  SoundCloudAPI.swift
//  Play
//
//  Created by Gene Yoo on 11/28/15.
//  Copyright © 2015 cs198-1. All rights reserved.
//

import Foundation

class SoundCloudAPI {
    func loadTracks(completion: (([Track]) -> Void)!) {
        let path = NSBundle.mainBundle().pathForResource("Info", ofType: "plist")
        let clientID = NSDictionary(contentsOfFile: path!)?.valueForKey("client_id") as! String
        let playlistID = "143983430"
        let url = NSURL(string: "http://api.soundcloud.com/playlists/\(playlistID)?client_id=\(clientID)")!
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                var tracks = [Track]()
                do {
                    let playlistDict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    let trackDataList = playlistDict.objectForKey("tracks") as! [NSDictionary]
                    for trackData in trackDataList {
                        let track = Track(data: trackData)
                        if (track.canStream!) {
                            tracks.append(track)
                        }
                    }
                    
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(tracks)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}