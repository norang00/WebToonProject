//
//  BannerView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit
import SnapKit

final class BannerView: UIView {

    private var images: [UIImage] = []
    private let imageView = UIImageView()
    private var currentIndex = 0
    
    private var timer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    private func configureView() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    func setImages(_ images: [UIImage]) {
        self.images = images
        if let first = images.first {
            imageView.image = first
        }
        startBannerRotation()
    }
    
    private func startBannerRotation() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(nextImage), userInfo: nil, repeats: true)
    }

    @objc private func nextImage() {
        guard !images.isEmpty else { return }
        currentIndex = (currentIndex + 1) % images.count
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.images[self.currentIndex]
        })
    }
    
    deinit {
        timer?.invalidate()
    }
}
