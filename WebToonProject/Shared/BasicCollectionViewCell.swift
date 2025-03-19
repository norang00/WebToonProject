//
//  BasicCollectionViewCell.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

final class BasicCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: BasicCollectionViewCell.self)
    
    @IBOutlet var mainImageView: UIImageView!
    
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainImageView.image = UIImage(systemName: "star")
        mainLabel.text = "mainLabel"
        subLabel.text = "subLabel"
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
