//
//  ViewController.swift
//  Photorama
//
//  Created by csuftitan on 4/10/23.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet weak var photosSegmentedControl: UISegmentedControl!
    
    @IBAction func photosSegmentChanged(_ sender: UISegmentedControl) {
        let predicate: NSPredicate?
        
        if sender.selectedSegmentIndex == 1 {
            predicate = NSPredicate(format: "favorite == true")
        } else {
            predicate = nil
        }
        
        updateDataSource(with: predicate)
    }
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        updateDataSource()

        store.fetchInterestingPhotos {
            (photosResult) -> Void in

            self.updateDataSource()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath =
                    collectionView.indexPathsForSelectedItems?.first {

                let photo = photoDataSource.photos[selectedIndexPath.row]

                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    private func updateDataSource(with predicate: NSPredicate? = nil) {
        store.fetchAllPhotos(with: predicate) { (photosResult) in
            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }

    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {

        let photo = photoDataSource.photos[indexPath.row]

        // Download the image data, which could take some time
        store.fetchImage(for: photo) { (result) -> Void in

            // The index path for the photo might have changed between the
            // time the request started and finished, so find the most
            // recent index path
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
                case let .success(image) = result else {
                    return
            }
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)

            // When the request finishes, find the current cell for this photo
            if let cell = self.collectionView.cellForItem(at: photoIndexPath)
                                                         as? PhotoCollectionViewCell {
                cell.update(displaying: image)
            }
        }
    }
}

//extension PhotosViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView,frame.size.width/4.15, height: collectionView.frame.size.height/7)
//    }
//}

