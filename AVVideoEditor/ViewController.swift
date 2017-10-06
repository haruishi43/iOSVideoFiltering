//
//  ViewController.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/05.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CoreImage

class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var playerView: AVPlayerView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeLabelContainerView: UIView!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Variables
    var imagePickerController: UIImagePickerController?
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    
    var timer: Timer?
    var isPlaying = false
    
    var currentFilter: Filter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    
    
}

