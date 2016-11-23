//
//  AudioViewController.swift
//  spotify
//
//  Created by Laura Evans on 11/23/16.
//  Copyright © 2016 Laura Evans. All rights reserved.
//

import UIKit
import AVFoundation

class AudioViewController: UIViewController {

    //MARK: Properties
    var track: Track!
    
    @IBOutlet weak var background: UIImageView!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        background.image = track.image
        albumImage.image = track.image
        songTitle.text = track.name
        
        downloadFileFromURL(url: URL(string: track.previewURL)!)
        
        playPauseButton.setTitle("Pause", for: .normal)
    }
    
    // Pause player if back button is pressed
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        player.pause()
    }
    
    //MARK: Methods
    func downloadFileFromURL(url: URL) {
        var downloadTask = URLSessionDownloadTask()
        downloadTask = URLSession.shared.downloadTask(with: url, completionHandler: {
                customURL, response, error in
            self.play(url: customURL!)
        })
        downloadTask.resume()
    }
    
    func play(url: URL) {
        do{
            player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print(error)
        }
    }
    
    @IBAction func playPause(_ sender: Any) {
        if player.isPlaying {
            player.pause()
            playPauseButton.setTitle("Play", for: .normal)
        } else {
            player.play()
            playPauseButton.setTitle("Pause", for: .normal)
        }
    }
    

}
