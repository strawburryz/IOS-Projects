//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by csuftitan on 4/17/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    @IBOutlet weak var favoriteButton: UIButton!

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        // We will implement this later
    }

    func update(displaying image: UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
}

