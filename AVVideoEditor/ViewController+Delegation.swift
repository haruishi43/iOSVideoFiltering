//
//  ViewController+Delegation.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/05.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices
import CoreImage

extension ViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // MARK: - Delegations
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        let fileURL = info[UIImagePickerControllerMediaURL] as? URL
        
        playerItem = AVPlayerItem(url: fileURL!)
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)

        player = AVPlayer(playerItem: playerItem)
        playerView.setPlayer(player!)
        
        // Setup the view after loading video
        
        uploadButton.isHidden = true
        playPauseButton.isHidden = false
        
        slider.maximumValue = Float(CMTimeGetSeconds((playerItem?.asset.duration)!))
        slider?.isHidden = false
        timeLabelContainerView?.isHidden = false
        let durInMiliSec = 1000 * CMTimeGetSeconds((playerItem?.asset.duration)!)
        timeLabel.text = formatInterval(durInMiliSec)
        
        filterButton.isHidden = false
        saveButton.isHidden = false
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification) {
        player?.seek(to: kCMTimeZero)
        isPlaying = false
        playPauseButton.setTitle("Play", for: .normal)
        timer?.invalidate()
        slider.value = 0
    }

}


// UIPopoverPresentationControllerDelegate
extension ViewController: UIPopoverPresentationControllerDelegate {
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // All menus should be popovers (even on iPhone).
        if let popoverController = segue.destination.popoverPresentationController, let button = sender as? UIButton {
            popoverController.delegate = self
            popoverController.sourceView = button
            popoverController.sourceRect = button.bounds
        }
        
        guard let identifier = segue.identifier,
            let segueIdentifer = SegueIdentifier(rawValue: identifier),
            segueIdentifer == .showFilter else { return }
        
        let filterViewController = segue.destination as! FilterSelectionViewController
        filterViewController.filters = FilterManager.availableFilters
        filterViewController.delegate = self
        
        // Set currentFilter to selected.
        if currentFilter != nil {
            let index = FilterManager.availableFilters.index(of: currentFilter!)
            filterViewController.selectedFilterRows.insert(index!)
        }
    }
}
