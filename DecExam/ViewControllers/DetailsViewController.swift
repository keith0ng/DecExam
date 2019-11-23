//
//  DetailsViewController.swift
//  DecExam
//
//  Created by Keith Samson on 11/22/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var itemModel: ItemModel?
    var itemImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let detailImage = UIImageView(frame: CGRect(x: 0, y: 10, width: view.frame.size.width / 2, height: view.frame.size.width / 2))
        
        let imageHeight = detailImage.frame.size.height
        let imageWidth = detailImage.frame.size.width
        
        detailImage.clipsToBounds = true
        detailImage.contentMode = .scaleAspectFill
        detailImage.backgroundColor = .green
        detailImage.center.x = view.center.x
        
        if let image = itemImage {
            detailImage.image = image
        } else {
            let photoURL = URL(string: itemModel?.thumbnailUrl ?? "")
            detailImage.sd_setImage(with: photoURL, completed: nil)
        }
        
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: imageHeight + 50, width: view.frame.size.width, height: 50))
        titleLabel.numberOfLines = 0
        titleLabel.text = "Title: \(itemModel?.title ?? "-")"
        let titleLabelHeight = titleLabel.frame.size.height
        
        let titleLabelYPos = titleLabel.frame.origin.y
        
        let idLabel = UILabel(frame: CGRect(x: 0, y: titleLabelYPos + titleLabelHeight, width: view.frame.size.width, height: 20))
        idLabel.text = "Photo ID: \(itemModel?.id ?? 0)"
        let idLabelYPos = idLabel.frame.origin.y
        let idLabelHeight = idLabel.frame.size.height
        
        let imageUrlLabel = UILabel(frame: CGRect(x: 0, y: idLabelYPos + idLabelHeight, width: view.frame.size.width, height: 20))
        imageUrlLabel.text = "URL: \(itemModel?.url ?? "-")"

        
        view.addSubview(detailImage)
        view.addSubview(titleLabel)
        view.addSubview(idLabel)
        view.addSubview(imageUrlLabel)
    }
}
