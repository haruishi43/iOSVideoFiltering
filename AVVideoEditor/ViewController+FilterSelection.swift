//
//  ViewController+FilterSelection.swift
//  AVVideoEditor
//
//  Created by Haruya Ishikawa on 2017/10/06.
//  Copyright © 2017 Haruya Ishikawa. All rights reserved.
//

import UIKit
import CoreImage
import AVFoundation

extension ViewController: FilterSelectionViewControllerDelegate {
    
    // MARK: - FilterSelectionViewControllerDelegate
    
    func filterSelectionViewController(_ selectionViewController: FilterSelectionViewController, didSelectFilter: Filter) {
        currentFilter = didSelectFilter
        
        // Add filter
        DispatchQueue.main.async {
            
            self.addFilter(didSelectFilter)
            
            self.hideFilterLoadingUI()
        }
        
        displayFilterLoadingUI()
    }
    
    func filterSelectionViewController(_ selectionViewController: FilterSelectionViewController, didDeselectFilter: Filter) {
        currentFilter = nil
        
        // Remove filter
        DispatchQueue.main.async {
            
            self.removeFilter(didDeselectFilter)
            
            self.hideFilterLoadingUI()
        }
        
        displayFilterLoadingUI()
    }
    
    // MARK: - Filtering
    
    func addFilter(_ filter: Filter) {
        
        guard playerItem != nil else {
            print("No video!")
            return
        }
        
        let ciFilter = CIFilter(name: filter.filter)!
        var composition: AVVideoComposition?
        
        switch filter.name {
        case "Sepia":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                ciFilter.setValue(0.8, forKey: kCIInputIntensityKey)
                
                let output = ciFilter.outputImage!
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
            
        case "Vignette":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                ciFilter.setValue(CIVector(x: request.sourceImage.extent.size.width / 2, y: request.sourceImage.extent.size.height / 2), forKey: kCIInputCenterKey)
                ciFilter.setValue((request.sourceImage.extent.size.width / 2), forKey: kCIInputRadiusKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Comic":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Fade":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Chrome":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Mono":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Instant":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Noir":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Process":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Tonal":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Transfer":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Gaussian":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                ciFilter.setValue(10.0, forKey: kCIInputRadiusKey)

                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        default:
            print("ERROR: default selected -> should not be here!")
        }
        
        if composition != nil {
            
            playerItem?.videoComposition = composition
        }
    }
    
    func removeFilter(_ filter: Filter) {
        
        // Remove all filters (if any)
        let composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
            
            // Clamp to avoid blurring transparent pixels at the image edges
            let source = request.sourceImage.clampedToExtent()
            
            // Provide the filter output to the composition
            request.finish(with: source, context: nil)
        })
        
        playerItem?.videoComposition = composition
        
    }
    
    
    // MARK: - Filter Loading UI
    
    func displayFilterLoadingUI() {
        
        // TODO: add spinner
        // TODO: spinner.startAnimating()
        
        filterButton.isEnabled = false
        filterButton.setImage(#imageLiteral(resourceName: "ring"), for: [])
        
    }
    
    func hideFilterLoadingUI() {
        
        // TODO: spinner.stopAnimating()
        
        filterButton.isEnabled = true
        filterButton.setImage(#imageLiteral(resourceName: "add"), for: [])
        
    }

}

