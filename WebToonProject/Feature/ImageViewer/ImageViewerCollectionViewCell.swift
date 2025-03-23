//
//  ImageViewerCollectionViewCell.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/22/25.
//

import UIKit
import Kingfisher

final class ImageViewerCollectionViewCell: UICollectionViewCell {

    static var identifier = String(describing: ImageViewerCollectionViewCell.self)

    @IBOutlet var cutImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cutImageView.image = nil
    }
    
    private func configureView() {
        cutImageView.contentMode = .scaleAspectFit
    }
    
    func configureData(_ data: Image) {
        guard let url = URL(string: data.link) else { return }
        let modifier = modifierForURL(url)
        cutImageView.kf.setImage(with: url,
                                 placeholder: UIImage(named: Resources.CustomImage.placeholder.rawValue),
                                 options: [.requestModifier(modifier)])
    }

    func modifierForURL(_ url: URL) -> ImageDownloadRequestModifier {
        return AnyModifier { request in
            var request = request
            let referer = "\(url.scheme ?? "https")://\(url.host ?? "")"
            request.setValue(referer, forHTTPHeaderField: "Referer")
            return request
        }
    }
}
