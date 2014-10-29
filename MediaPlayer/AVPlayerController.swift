//
//  AVPlayerController.swift
//  AudioPlayer
//
//  Created by Lanvige Jiang on 10/28/14.
//  Copyright (c) 2014 Lanvige Jiang. All rights reserved.
//

import UIKit
import AVFoundation

class AVPlayerController: UIViewController {

    let remoteUrl: String? = "http://yinyueshiting.baidu.com/data2/music/122879337/104937211414281661128.mp3?xcode=aff7a81a9ee87b97b59f0140af7f1168f8bf0cbfdda701d1"
    
    var playerItem: AVPlayerItem?
    var player: AVPlayer!
    var duration :Float?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var seekSlider: UISlider!
    @IBOutlet weak var currentTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.lightGrayColor()
        
        var url = NSURL(string: self.remoteUrl!)
        var asset: AVAsset = AVURLAsset(URL: url, options: nil)
        
        self.playerItem = AVPlayerItem(asset: asset)
        self.player = AVPlayer(playerItem: self.playerItem)
        
        self.startObservingPlayer(self.player)
        
        
        self.setDuration()
        self.addPeriodic()
        self.initSeedBar()
        
        // 视频 FileMode? AVPlayerLayer
        // https://gist.github.com/yoshimin/a14e6fb592f736aafc68
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.pause()
        self.stopObservingPlayer(self.player!)
    }

    deinit {
        self.pause()
        self.stopObservingPlayer(self.player!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // - MARK:
    
    func initSeedBar() {
        self.seekSlider.minimumValue = 0
        self.seekSlider.maximumValue = self.duration!
        
        self.seekSlider.addTarget(self, action: "onSliderValueChange:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func addPeriodic() {
        let interval = CMTimeMake(33, 1000) // 30fps
        self.player.addPeriodicTimeObserverForInterval(interval, queue: nil) { (time) -> Void in
            self.syncSeekber()
            self.updateTimeLabel()
        }
    }
    
    func setDuration() {
        var time: CMTime = self.player!.currentItem.asset.duration
        self.duration = Float(CMTimeGetSeconds(time))
        
        self.durationLabel!.text = String(format: "%.2f", self.duration!)
    }
    
    func syncSeekber() {
        // 総再生時間を取得.
        let duration = CMTimeGetSeconds(self.player!.currentItem.duration)
        
        // 現在の時間を取得.
        let time = CMTimeGetSeconds(self.player!.currentTime())
        
        // シークバーの位置を変更.
        let value = Float(self.seekSlider.maximumValue - self.seekSlider.minimumValue) * Float(time) / self.duration! + Float(self.seekSlider.minimumValue)
        self.seekSlider.value = value
    }
    
    func updateTimeLabel() {
        // 現在の時間を取得.
        let time = CMTimeGetSeconds(self.player!.currentTime())
        
        self.currentTimeLabel.text = String(format: "%.2f", time)
    }
    
    // シークバーの値が変わった時に呼ばれるメソッド.
    func onSliderValueChange(sender : UISlider){
        // 動画の再生時間をシークバーとシンクロさせる.
        self.player.seekToTime(CMTimeMakeWithSeconds(Float64(seekSlider.value), Int32(NSEC_PER_SEC)))
    }
    
    
    // - MARK:
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if (keyPath == "status") {
            if (self.player.status ==  AVPlayerStatus.Failed) {
                NSLog("Failed")
            } else if (self.player!.status == AVPlayerStatus.ReadyToPlay) {
                NSLog("Ready")
            } else if (self.player!.status == AVPlayerStatus.Unknown) {
                NSLog("Unkonw Issue")
            }
        }
    }
    
    //
    func startObservingPlayer(player: AVPlayer) {
        let options = NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old
        player.addObserver(self, forKeyPath: "status", options: options, context: nil)
    }
    
    func stopObservingPlayer(player: AVPlayer) {
        player.removeObserver(self, forKeyPath: "status", context: nil)
    }
    
    // - MARK:

    @IBAction func playButtonTapped(sender: UIButton) {
//        self.player.seekToTime(CMTimeMakeWithSeconds(0, Int32(NSEC_PER_SEC)))
        self.player.play()
    }

    @IBAction func pauseButtonTapped(sender: AnyObject) {
        self.player.pause()
    }
    
    
    func play() {
        self.player.play()
    }
    
    func pause() {
        self.player.pause()
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
