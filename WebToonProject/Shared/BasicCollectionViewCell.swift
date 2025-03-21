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
        // infoImageView
        let image: UIImage? = data.isUpdated ? UIImage(named: Resources.CustomImage.isUpdated.rawValue)
                            : data.isFree ? UIImage(named: Resources.CustomImage.isFree.rawValue)
                            : data.isEnd ? UIImage(named: Resources.CustomImage.isEnd.rawValue)
                            : nil
        infoImageView.image = image
        infoImageView.contentMode = .scaleAspectFit

        // mainImageView
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

        // Labels
        mainLabel.font = .pretendardRegular(ofSize: 14)
        mainLabel.text = data.title

        subLabel.font = .pretendardMedium(ofSize: 12)
        subLabel.text = data.authors.first ?? ""
        subLabel.textColor = .textGray
    }
    
}
