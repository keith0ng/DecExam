//
//  ItemCollectionViewCell.swift
//  DecExam
//
//  Created by Keith Samson on 11/22/19.
//  Copyright © 2019 Keith Samson. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    var cellImage: UIImageView?
    var mainLabel: UILabel?
    var subLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let cellHeight = frame.size.height
        let cellWidth = frame.size.width
        
        cellImage = UIImageView(frame: CGRect(x: 0, y: 0, width: cellHeight, height: cellHeight))
        let imageHeight = cellImage?.frame.size.height ?? 0
        let imageWidth = cellImage?.frame.size.width ?? 0
        
        cellImage?.layer.cornerRadius = imageHeight / 2
        
        cellImage?.clipsToBounds = true
        cellImage?.contentMode = .scaleAspectFill
        
        mainLabel = UILabel(frame: CGRect(x: imageWidth + 10, y: (cellHeight / 2) - 50, width: (cellWidth - imageWidth) - 10, height: 50))
        mainLabel?.numberOfLines = 0

        let mainLabelYPos = mainLabel?.frame.origin.y ?? 0
        let mainLabelHeight = mainLabel?.frame.size.height ?? 0
        
        subLabel = UILabel(frame: CGRect(x: imageWidth + 10, y: mainLabelYPos + mainLabelHeight, width: cellWidth - imageWidth, height: 20))
        
        subLabel?.font = subLabel?.font.withSize(13)
        
        if let _ = cellImage {
            addSubview(cellImage!)
        }
        
        if let _ = mainLabel {
            addSubview(mainLabel!)
        }
        
        if let _ = subLabel {
            addSubview(subLabel!)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        mainLabel?.text = ""
        subLabel?.text = ""
        cellImage?.image = nil
    }

    
}
