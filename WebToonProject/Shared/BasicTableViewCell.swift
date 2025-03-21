//
//  BasicTableViewCell.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/20/25.
//

import UIKit
import Kingfisher

class BasicTableViewCell: UITableViewCell {
    
    static var identifier = String(describing: BasicTableViewCell.self)

    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet var ratingLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configureData(_ data: Webtoon) {
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
        titleLabel.font = .bodyFont
        titleLabel.text = data.title
        
        authorLabel.font = .captionFont
        authorLabel.text = data.authors.isEmpty ? "" :
                           data.authors.joined(separator: ", ")
        authorLabel.textColor = .accent

        // Ratings
        let dummyRating = round(Double.random(in: 0...5)*10)/10
        colorStarImages(dummyRating)

        ratingLabel.font = .captionFont
        ratingLabel.text = "(\(dummyRating))"
        ratingLabel.textColor = .textGray
    }
    
    private func colorStarImages(_ grade: Double) {
        var grade = grade
        for index in 0..<5 {
            if grade >= 1 {
                starImageViews[index].image = UIImage(named: Resources.CustomImage.starGreen.rawValue)
            } else {
                starImageViews[index].image = UIImage(named: Resources.CustomImage.starGray.rawValue)
            }
            starImageViews[index].contentMode = .scaleAspectFit
            grade -= 1
        }
    }
}
