//
//  BasicCollectionViewCell.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import Kingfisher

final class BasicCollectionViewCell: UICollectionViewCell {
    
    static var identifier = String(describing: BasicCollectionViewCell.self)
    
    @IBOutlet var infoImageView: UIImageView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var mainLabel: UILabel!
    @IBOutlet var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureData(_ data: Webtoon) {
        let isEndImage = UIImage(named: Resources.CustomImage.isEnd.rawValue)
        let isFreeImage = UIImage(named: Resources.CustomImage.isFree.rawValue)
        let isUpdatedImage = UIImage(named: Resources.CustomImage.isUpdated.rawValue)
        
        if data.isUpdated {
            infoImageView.image = isUpdatedImage
        } else if data.isFree {
            infoImageView.image = isFreeImage
        } else if data.isEnd {
            infoImageView.image = isEndImage
        } else {
            infoImageView.image = nil // 아무 이미지도 표시하지 않음
        }
        infoImageView.contentMode = .scaleAspectFit

        guard let thumbnailString = data.thumbnail.first,
              let url = URL(string: thumbnailString) else { return }

        let modifier = AnyModifier { request in
            var request = request
            request.setValue("https://comic.naver.com", forHTTPHeaderField: "Referer")
            return request
        }
        
        mainImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "basicImage"), options: [.requestModifier(modifier)])
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true

        mainLabel.text = data.title
        subLabel.text = data.authors.first ?? ""
    }
    
}
