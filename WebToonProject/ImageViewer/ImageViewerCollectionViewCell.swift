//
//  ImageViewerCollectionViewCell.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import Kingfisher

class ImageViewerCollectionViewCell: UICollectionViewCell {

    static var identifier = String(describing: ImageViewerCollectionViewCell.self)

    @IBOutlet var cutImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // [TODO]
    }
    
    private func configureView() {
        cutImageView.contentMode = .scaleAspectFit
    }
    
    func configureData(_ url: URL) {
        print(url)
        cutImageView.kf.setImage(with: url)
    }

}
