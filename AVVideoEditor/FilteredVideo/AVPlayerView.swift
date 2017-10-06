//
//  AVPlayerView.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/05.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//
import UIKit
import AVFoundation

class AVPlayerView: UIView {
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerItem: AVPlayerItem? {
        get {
            return player?.currentItem
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    func setPlayer(_ player: AVPlayer) {
        let layer = AVPlayerLayer(player: player)
        layer.frame = self.bounds
        layer.videoGravity = .resizeAspect
        self.layer.insertSublayer(layer, below: self.subviews.first?.layer)
    }
    
}
