//
//  ViewController.swift
//  Photorama
//
//  Created by csuftitan on 4/10/23.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var favoritesView: UIView!
    
    
    @IBOutlet var segmentedControlView: UISegmentedControl!
    
    @IBAction func segmentedControlView(_ sender: UISegmentedControl) {
        
        switch segmentedControlView.selectedSegmentIndex
            {
            case 0:
            collectionView.isHidden = false
            favoritesView.isHidden = true
            case 1:
            collectionView.isHidden = true
            favoritesView.isHidden = false
            default:
                break;
            }
        
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
    
    private func updateDataSource() {
        store.fetchAllPhotos {
            (photosResult) in

            switch photosResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case .failure:
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

//extension PhotosViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: collectionView,frame.size.width/4.15, height: collectionView.frame.size.height/7)
//    }
//}

