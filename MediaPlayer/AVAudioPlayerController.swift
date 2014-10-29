//
//  AVAudioPlayerController.swift
//  AudioPlayer
//
//  Created by Lanvige Jiang on 10/28/14.
//  Copyright (c) 2014 Lanvige Jiang. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AVAudioPlayerController: UIViewController {

    var p: MPMoviePlayerViewController?
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGrayColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
