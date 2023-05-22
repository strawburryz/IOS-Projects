//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by csuftitan on 4/19/23.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    @IBOutlet weak var viewCountLabel: UILabel!
    
    
    @IBAction func favoriteButtonTapped(_ sender: UIBarButtonItem) {
        guard let photo = photo else { return }
            
            // Toggle the isFavorite attribute
            photo.favorite.toggle()
            
            // Save the changes
            do {
                try store.persistentContainer.viewContext.save()
            } catch {
                print("Error saving the updated photo: \(error)")
            }
            
            // Update the button appearance
            updateFavoriteButton()
    }
    
    func updateFavoriteButton() {
        if let photo = photo {
            let systemName = photo.favorite ? "star.fill" : "star"
            favoriteButton.image = UIImage(systemName: systemName)
            
            viewCountLabel.text = "Views: \(photo.viewCount)"
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Increment the view count and save the changes
        photo.viewCount += 1
        do {
            try store.persistentContainer.viewContext.save()
        } catch {
            print("Error saving view count: \(error)")
        }
        
        // Update the UI
        updateFavoriteButton()
    }

    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags":
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController

            tagController.store = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        store.fetchImage(for: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
    
}
