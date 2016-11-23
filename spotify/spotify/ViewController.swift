//
//  TableViewController.swift
//  spotify
//
//  Created by Laura Evans on 11/23/16.
//  Copyright © 2016 Laura Evans. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

var player = AVAudioPlayer()

class TableViewController: UITableViewController, UISearchBarDelegate {
    
    //MARK: Properties
    
    var tracks = [Track]()
    var searchUrl: String!
    typealias JSONStandard = [String : AnyObject]
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

    }
    
    //MARK: Methods
    func callAlamo(url: String) {
        Alamofire.request(url).responseJSON(completionHandler: {
            response in
            
            self.parseData(JSONData: response.data!)
        })
    }
    
    func parseData(JSONData: Data) {
        do {
            let readableJSON = try JSONSerialization.jsonObject(with: JSONData, options: .mutableContainers) as! JSONStandard
            
            guard let albumTracks = readableJSON["tracks"] as? JSONStandard else {
                print("unable to parse tracks")
                return
            }
            
            guard let items = albumTracks["items"] as? [JSONStandard] else {
                print("unable to parse items")
                return
            }
    
            for i in 0..<items.count {
                let item = items[i] 
                let trackName = item["name"] as! String
                let previewURL = item["preview_url"] as! String
                
                // grab track image
                guard let album = item["album"] as? JSONStandard else {
                    print("could not parse album")
                    return
                }
                
                guard let images = album["images"] as? [JSONStandard] else {
                    print("could not parse images")
                    return
                }
                
                
                let image = images[0]
                let imageURL = URL(string: image["url"] as! String)
                let imageData = NSData(contentsOf: imageURL!)
                let trackImage = UIImage(data: imageData as! Data)
                
                let track = Track(name: trackName, image: trackImage, previewURL: previewURL)
                tracks.append(track)
            }
            
            self.tableView.reloadData()
            
            
        } catch {
            print(error)
        }
    }
    
    //MARK: Tableview functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        let track = tracks[indexPath.row]

        let cellImageView = cell?.viewWithTag(2) as! UIImageView
        let cellLabel = cell?.viewWithTag(1) as! UILabel
        
        cellImageView.image = track.image
        cellLabel.text = track.name
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPathForSelectedRow?.row
        let audioViewController = segue.destination as! AudioViewController
        
        audioViewController.track = tracks[indexPath!]
    }
    
    //MARK: SearchBar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text
        let keywords = searchText?.replacingOccurrences(of: " ", with: "+")
        searchUrl = "https://api.spotify.com/v1/search?q=\(keywords!)&type=track"
        
        callAlamo(url: searchUrl)
        
        self.view.endEditing(true)
    }

}

