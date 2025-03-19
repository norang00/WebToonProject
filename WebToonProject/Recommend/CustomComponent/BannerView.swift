//
//  BannerView.swift
//  WebToonProject
//
//  Created by Kyuhee hong on 3/19/25.
//

import UIKit

final class BannerView: BaseView {
    
    private var imageView = UIImageView()
    private var images: [UIImage] = []
    private var currentIndex = 0
    private var timer: Timer?

    override func configureHierarchy() {
        addSubview(imageView)
    }
    
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configureView() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = self.bounds
    }
    
    // 이미지 배열을 설정하고 타이머를 시작
    func setImages(_ images: [UIImage]) {
        self.images = images
        if let first = images.first {
            imageView.image = first
        }
        startTimer()
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.nextImage()
        }
    }
    
    private func nextImage() {
        guard !images.isEmpty else { return }
        currentIndex = (currentIndex + 1) % images.count
        UIView.transition(with: imageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.imageView.image = self.images[self.currentIndex]
        }, completion: nil)
    }
    
    deinit {
        timer?.invalidate()
    }
    
}
