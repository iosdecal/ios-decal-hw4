//
//  SoundCloudAPI.swift
//  Play
//
//  Created by Gene Yoo on 11/28/15.
//  Copyright © 2015 cs198-1. All rights reserved.
//

import Foundation

class SoundCloudAPI {
    func loadTracks(_ completion: (([Track]) -> Void)!) {
        let path = Bundle.main.path(forResource: "Info", ofType: "plist")
        let clientID = NSDictionary(contentsOfFile: path!)?.value(forKey: "client_id") as! String
        let playlistID = "143983430"
        let url = URL(string: "http://api.soundcloud.com/playlists/\(playlistID)?client_id=\(clientID)")!

        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: url) {(data, response, error) -> Void in
            if error == nil {
                var tracks = [Track]()
                do {
                    let playlistDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    let trackDataList = playlistDict.object(forKey: "tracks") as! [NSDictionary]
                    for trackData in trackDataList {
                        let track = Track(data: trackData)
                        if (track.canStream!) {
                            tracks.append(track)
                        }
                    }

                    DispatchQueue.global(qos: .background).async {
                        DispatchQueue.main.async {
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
