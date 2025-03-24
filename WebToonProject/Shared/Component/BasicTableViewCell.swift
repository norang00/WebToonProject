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

    @IBOutlet var infoImageView: UIImageView!
    @IBOutlet var mainImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var starImageViews: [UIImageView]!
    @IBOutlet var ratingLabel: UILabel!

    private var shimmerViews: [ShimmerView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // [TODO]
    }
    
    private func configureView() {
        infoImageView.contentMode = .scaleAspectFit

        mainImageView.contentMode = .scaleAspectFill
        mainImageView.clipsToBounds = true

        titleLabel.font = .bodyFont

        authorLabel.font = .captionFont
        authorLabel.textColor = .textGray

        ratingLabel.font = .captionFont
        ratingLabel.textColor = .textGray
    }
    
    func configureData(_ data: Webtoon) {
        let image: UIImage? =
        data.isUpdated ? UIImage(named: Resources.CustomImage.isUpdated.rawValue)
        : data.isEnd ? UIImage(named: Resources.CustomImage.isEnd.rawValue)
        : data.isFree ? UIImage(named: Resources.CustomImage.isFree.rawValue)
        : nil
        infoImageView.image = image
        
        guard let thumbnailString = data.thumbnail.first,
              let url = URL(string: thumbnailString) else { return }

        let modifier = AnyModifier { request in
            var request = request
            request.setValue("https://comic.naver.com",
                             forHTTPHeaderField: "Referer")
            return request
        }

        mainImageView.kf.setImage(with: url, placeholder: UIImage(systemName: "basicImage"), options: [.requestModifier(modifier)])

        titleLabel.text = data.title
        
        authorLabel.text = data.authors.isEmpty ? "" :
                           data.authors.joined(separator: ", ")

        let dummyRating = Double.random(in: 3...5)
        colorStarImages(dummyRating)
        ratingLabel.text = "(\(String(format: "%.1f", dummyRating)))"
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
    
    func showShimmer() {
        let viewsToShimmer: [UIView] = [
            infoImageView, mainImageView, titleLabel, authorLabel, ratingLabel
        ] + starImageViews
        viewsToShimmer.forEach {
            let shimmer = ShimmerView.apply(to: $0)
            shimmerViews.append(shimmer)
        }
    }
    
    func hideShimmer() {
        shimmerViews.forEach { $0.stopShimmering() }
        shimmerViews.removeAll()
    }
    
    func hideRatingInfo() {
        infoImageView.isHidden = true
        ratingLabel.isHidden = true
        starImageViews.forEach { $0.isHidden = true }
    }
}
