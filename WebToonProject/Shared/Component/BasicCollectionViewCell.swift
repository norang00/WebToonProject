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
        
        mainLabel.font = .pretendardRegular(ofSize: 14)
        
        subLabel.font = .pretendardMedium(ofSize: 12)
        subLabel.textColor = .textGray
    }
    
    func configureData(_ data: Webtoon) {
        let image: UIImage? = data.isUpdated ? UIImage(named: Resources.CustomImage.isUpdated.rawValue)
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
        
        mainImageView.kf.setImage(with: url,
                                  placeholder: UIImage(systemName: "basicImage"),
                                  options: [.requestModifier(modifier)])
        
        mainLabel.text = data.title
        
        subLabel.text = data.authors.joined(separator: ", ")
    }
    
    func showShimmer() {
        let viewsToShimmer: [UIView] = [
            infoImageView, mainImageView, mainLabel, subLabel
        ]
        viewsToShimmer.forEach {
            let shimmer = ShimmerView.apply(to: $0)
            shimmerViews.append(shimmer)
        }
    }
    
    func hideShimmer() {
        shimmerViews.forEach { $0.stopShimmering() }
        shimmerViews.removeAll()
    }
}
