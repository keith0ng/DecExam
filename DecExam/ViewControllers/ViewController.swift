//
//  ViewController.swift
//  DecExam
//
//  Created by Keith Samson on 11/22/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    var collectionView: UICollectionView?
    var itemList: [ItemModel]? = [] {
        didSet {
            DispatchQueue.main.async { self.collectionView?.reloadData() } // Reload the table after list is populated
        }
    }
    
    var photoArray: [String: UIImage?]? = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        
        let itemWidth = view.frame.size.width
        let itemHeight = itemWidth / 3
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(ItemCollectionViewCell.self, forCellWithReuseIdentifier: "CollectionCell")
        collectionView?.backgroundColor = UIColor.white
        view.addSubview(collectionView ?? UIView())
        
        DispatchQueue.global().async { self.getItemList() } // Download items in background thread
    }
    
    func getItemList() {
        // Use a better API request especially on projects with several endpoints. Alamofire is the most common.
        // For simplicity, use the URL Session.
        let url = "https://jsonplaceholder.typicode.com/photos?_limit=50"
        
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, err -> Void in
            self.itemList = self.getItemsFromData(data: data)
        })
        
        task.resume()
    }
    
    func getItemsFromData(data: Data?) -> [ItemModel]? {
        if let _ = data {
            do {
                var itemReponse: [ItemModel]
                try itemReponse = JSONDecoder().decode([ItemModel].self, from: data!)
                return itemReponse
            } catch {
                print("Error Downloading items.")
                return []
            }
        }
        return []
    }
}
// MARK: - Shake Motion
extension ViewController {
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shake")
            let alert = UIAlertController(title: "Test", message: "Hello, world", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            alert.showWindowPopUp()

        }
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = itemList?[indexPath.row]
        let detailsVC = DetailsViewController()
        detailsVC.itemModel = item
        
        if let itemImage = photoArray?[item?.thumbnailUrl ?? ""] as? UIImage {
            detailsVC.itemImage = itemImage
        }
        
        show(detailsVC, sender: self)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? ItemCollectionViewCell
        
        if (itemList?.count)! <= 0 {
            return collectionCell!
        }
        
        let item = itemList?[indexPath.row]
        
        
        let photoCount = photoArray?.count ?? 0
        
        if (photoCount) > 0, let photo = photoArray?[item?.thumbnailUrl ?? ""] {
            collectionCell?.cellImage?.image = photo
        } else {
            let imageURL = URL(string: (item?.thumbnailUrl) ?? "")
            // Using SDWebImage simplifies the download of photos and caching
            // especially on larger size photos.
            collectionCell?.cellImage?.sd_setImage(with: imageURL, completed: { (image, error, cacheType, url) in
                if error != nil {
                    print("Error downloading photo \(error)")
                } else {
                    let urlString = "\(url!)"
                    self.photoArray?[urlString] = image
                }
            })
        }
        
        collectionCell?.mainLabel?.text = "Title: \(item?.title ?? "")"
        collectionCell?.subLabel?.text = "Photo ID: \(item?.id ?? 0)"
        
        return collectionCell!
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList?.count == 0 ? 1 : (itemList?.count)!
    }
}

// MARK: - Windows Popup
var windowsPopUp: UIWindow?
public extension UIAlertController {
    func showWindowPopUp() {
        windowsPopUp = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .black
        windowsPopUp!.rootViewController = vc
        windowsPopUp!.windowLevel = UIWindow.Level.alert + 1
        windowsPopUp!.makeKeyAndVisible()
        vc.present(self, animated: true)
    }
}
