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
    
    func configureData(_ data: Webtoon) {
        mainLabel.text = data.title
        subLabel.text = data.authors.first ?? ""
        
        guard let thumbnailString = data.thumbnail.first,
              let url = URL(string: thumbnailString) else {
            // URL이 없거나 잘못된 경우 기본 이미지 사용
            mainImageView.image = UIImage(systemName: "star")
            return
        }
        // Referer 헤더 추가 (네이버 웹툰 이미지는 일반적으로 comic.naver.com 을 참조)
        let modifier = AnyModifier { request in
            var request = request
            request.setValue("https://comic.naver.com", forHTTPHeaderField: "Referer")
            return request
        }
        
        mainImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "star"),
            options: [.requestModifier(modifier)],
            completionHandler: { result in
                switch result {
                case .success(let value):
                    print("Image loaded: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        )
        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true
        
    }
}
