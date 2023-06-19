//
//  UITableViewControllerExtension.swift
//  JarrodsMenuRev
//
//  Created by Jason Carter on 4/4/22.
//

import UIKit

extension UITableViewController {
    // go through the list of visible cells
    func fitDetailLabels() {
        for cell in tableView.visibleCells {
            fitDetailLabel(in: cell)
        }
    }
    // fit price label in cells
    func fitDetailLabel(in cell: UITableViewCell) {
        // get the image view
        guard let imageView = cell.imageView else { return }
        
        // get the main text label
        guard let textLabel = cell.textLabel else { return }
        
        // get the detail text label
        guard let detailTextLabel = cell.detailTextLabel else { return }
        
        // get the width of image view
        let imageWidth = imageView.frame.width
        
        // remember the original width of main text label
        let textWidth = textLabel.frame.width
        
        // remember the original width of detail text label
        let detailWidth = detailTextLabel.frame.width
        
        // calculate the total width of image and two labels
        let totalWidth = imageWidth + textWidth + detailWidth
        
        // fit the detail text label
        detailTextLabel.sizeToFit()
        
        // make sure the image width does not change
        imageView.frame.size.width = imageWidth
        
        // get the new detail text label width
        let newDetailWidth = detailTextLabel.frame.width
        
        // calculate the new main text label width based on detailed text label widht
        let newTextWidth = totalWidth - imageWidth - newDetailWidth
        
        guard newTextWidth < textWidth else { return }
        
        // set the new width of main text label
        textLabel.frame.size.width = newTextWidth
        
        // fit the width with new font
        textLabel.adjustsFontSizeToFitWidth = true
        
        // move the new origin of detail text label
        detailTextLabel.frame.origin.x -= newDetailWidth - detailWidth
    }
    
    //fit image in cell
    func fitImage(in cell: UITableViewCell) {
        guard let imageView = cell.imageView else { return }
        
        let oldWidth = imageView.frame.width
        
        imageView.frame.size = CGSize(width: 100, height: 100)
        
        let leftShift = oldWidth - imageView.frame.width
        
        guard let textLabel = cell.textLabel else { return }

        textLabel.frame.origin.x -= leftShift
    }
}
