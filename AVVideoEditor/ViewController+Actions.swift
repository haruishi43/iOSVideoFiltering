//
//  ViewController+Actions.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/05.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//
import UIKit
import AVFoundation
import MobileCoreServices
import CoreImage
import Photos

extension ViewController {
    
    enum SegueIdentifier: String {
        case showFilter
    }
    
    // MARK: - Button Actions
    
    @IBAction func uploadButtonTouched(_ sender: Any) {
        imagePickerController = UIImagePickerController()
        imagePickerController?.mediaTypes = [kUTTypeMovie as String]
        imagePickerController?.delegate = self
        
        let actionSheet = UIAlertController(title: "Select Video", message: "Choose where to get the video from", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        //------- Choosing images from camera bugs the process: ----->
//        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(_ action: UIAlertAction) -> Void in
//            self.imagePickerController?.sourceType = .camera
//            self.present(self.imagePickerController!, animated: true)
//        }))
        
        // Photo Album
        actionSheet.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            self.imagePickerController?.sourceType = .photoLibrary
            self.present(self.imagePickerController!, animated: true)
        }))
        
        present(actionSheet, animated: true)
        
    }
    
    @IBAction func chooseFilter(_ button: UIButton) {
        
        // TODO: Remove any filter on video if any?
        
        performSegue(withIdentifier: SegueIdentifier.showFilter.rawValue, sender: button)
    }
    
    @IBAction func playPauseButtonTouched(_ sender: Any) {
        if isPlaying {
            player?.pause()
            playPauseButton.setTitle("Play", for: .normal)
            timer?.invalidate()
        } else {
            player?.play()
            playPauseButton.setTitle("Pause", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateSlider), userInfo: nil, repeats: true)
            
        }
        isPlaying = !isPlaying
    }
    
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player?.seek(to: CMTimeMakeWithSeconds(Float64((sender).value), Int32(Double(NSEC_PER_SEC))), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero)
        updateTimeLabel()
    }
    
    @IBAction func saveButtonTouched(_ sender: UIButton) {
        
        guard let currentItem = player?.currentItem else { return }
        saveButton.isHidden = true
        let export = AVAssetExportSession(asset: currentItem.asset, presetName: AVAssetExportPresetHighestQuality)
        export?.outputFileType = AVFileType.mov
        export?.videoComposition = currentItem.videoComposition
        
        let exportPath = self.generateExportPath()
        if FileManager.default.fileExists(atPath: exportPath) {
            do {
                try FileManager.default.removeItem(atPath: exportPath)
            } catch _ {
                print("Error: AVMediaTypeVideo")
                return
            }
        }
        let exportURL = URL(fileURLWithPath: exportPath)
        export?.outputURL = exportURL

        export?.exportAsynchronously(completionHandler: { () -> Void in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: exportURL)
            }) { saved, error in
                if saved {
                    let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.saveButton.isHidden = false
                }
                else {
                    print(error!)
                }
            }
        })
    }
    
    
    // MARK: - Supporting Funcitons
    
    @objc func updateSlider() {
        let val: CGFloat = CGFloat(slider.value + 0.1)
        slider.value = Float(val)
        updateTimeLabel()
        
    }
    
    func updateTimeLabel() {
        let dur: Float64 = CMTimeGetSeconds(player!.currentTime())
        let durInMiliSec = 1000 * dur
        timeLabel.text = formatInterval(durInMiliSec)
    }
    
    func formatInterval(_ totalMilliseconds: Float64) -> String {
        var milliseconds = UInt(totalMilliseconds)
        var seconds: UInt = milliseconds / 1000
        milliseconds %= 1000
        let minutes: UInt = seconds / 60
        seconds %= 60
        return String(format: "%02lu:%02lu.%02lu", minutes, seconds, milliseconds)
    }
    
    func generateExportPath() -> String {
        let videoName: String = "video" + ".mov"
        return NSTemporaryDirectory().appending("/" + videoName)
    }
    
}
