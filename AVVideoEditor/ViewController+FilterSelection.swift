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
        
        
        var composition: AVVideoComposition?
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        switch filter.name {
        case "Fancy":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage
                
                // Fitlers
                let colorFilter1 = CIFilter(name: "CIColorPolynomial")
                let fancyLensFilterColor1 = UIColor(red:0.00, green:0.71, blue:1.00, alpha:0.16)
                let colorControlFilter = CIFilter(name: "CIColorControls")
                let colorFilter2 = CIFilter(name: "CIColorPolynomial")
                let fancyLensFilterColor2 = UIColor(red:1.00, green:0.49, blue:0.87, alpha:0.1)

                // Filter details
                colorFilter1?.setValue(source, forKey: kCIInputImageKey)
                fancyLensFilterColor1.getRed(&r, green: &g, blue: &b, alpha: &a)
                colorFilter1?.setValue(CIVector(x: 0, y: 1, z: 0, w: r), forKey: "inputRedCoefficients")
                colorFilter1?.setValue(CIVector(x: 0, y: 1, z: 0, w: g), forKey: "inputGreenCoefficients")
                colorFilter1?.setValue(CIVector(x: 0, y: 1, z: 0, w: b), forKey: "inputBlueCoefficients")
                colorFilter1?.setValue(CIVector(x: 0, y: 1, z: 0, w: a), forKey: "inputAlphaCoefficients")
                var filteredImage: CIImage? = colorFilter1?.outputImage
                
                colorControlFilter?.setValue(filteredImage, forKey: kCIInputImageKey)
                colorControlFilter?.setValue(0.64, forKey: "inputSaturation")
                colorControlFilter?.setValue(0.05, forKey: "inputBrightness")
                colorControlFilter?.setValue(0.36, forKey: "inputContrast")
                filteredImage = colorControlFilter?.outputImage
                
                colorFilter2?.setValue(filteredImage, forKey: kCIInputImageKey)
                fancyLensFilterColor2.getRed(&r, green: &g, blue: &b, alpha: &a)
                colorFilter2?.setValue(CIVector(x: 0, y: 1, z: 0, w: r), forKey: "inputRedCoefficients")
                colorFilter2?.setValue(CIVector(x: 0, y: 1, z: 0, w: g), forKey: "inputGreenCoefficients")
                colorFilter2?.setValue(CIVector(x: 0, y: 1, z: 0, w: b), forKey: "inputBlueCoefficients")
                colorFilter2?.setValue(CIVector(x: 0, y: 1, z: 0, w: a), forKey: "inputAlphaCoefficients")
                filteredImage = colorFilter2?.outputImage
                
                request.finish(with: filteredImage!, context: nil)
            })
            
        case "Vignette":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
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
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Fade":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Chrome":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Mono":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Instant":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Noir":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Process":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Tonal":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Transfer":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                
                let output = ciFilter.outputImage!.cropped(to: request.sourceImage.extent)
                
                // Provide the filter output to the composition
                request.finish(with: output, context: nil)
            })
        case "Gaussian":
            composition = AVVideoComposition(asset: (playerItem?.asset)!, applyingCIFiltersWithHandler: { request in
                
                // Clamp to avoid blurring transparent pixels at the image edges
                let source = request.sourceImage.clampedToExtent()
                let ciFilter = CIFilter(name: filter.filter)!
                ciFilter.setValue(source, forKey: kCIInputImageKey)
                ciFilter.setValue(3.0, forKey: kCIInputRadiusKey)

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

