//
//  PreviewService.swift
//  News
//
//  Created by Dzmitry Bosak on 12/5/18.
//  Copyright © 2018 Dzmitry Bosak. All rights reserved.
//

import UIKit

final class PreviewService {
    
    // MARK: - Singleton
    
    static let shared = PreviewService()
    private init() {}
    
    // MARK: - Properties
    
    private var timer: Timer?
    
    private let minInterval: TimeInterval = 15
    private let maxInterval: TimeInterval = 45
    
    // MARK: - Main method
    
    func presentByTimer(in rootViewController: UIViewController) {
        timer = Timer.scheduledTimer(withTimeInterval: random(from: minInterval, to: maxInterval), repeats: true) { [weak self] _ in
            self?.presentArticlePreview(in: rootViewController)
        }
    }
    
    // MARK: - Private methods
    
    private func random(from min: TimeInterval, to max: TimeInterval) -> TimeInterval {
        let randomValue = TimeInterval.random(in: min...max)
        print("Timer Interval: \(randomValue)")
        return randomValue
    }
    
    private func presentArticlePreview(in rootViewController: UIViewController) {
        let articlePreviewViewController = ArticlePreviewViewController()
        let navigationController = UINavigationController(rootViewController: articlePreviewViewController)
        navigationController.modalPresentationStyle = .overCurrentContext
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.navigationBar.isHidden = true
        
        navigationController.navigationBar.barTintColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        navigationController.navigationBar.backgroundColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        navigationController.navigationBar.tintColor = .white
        
        rootViewController.present(navigationController, animated: true)
    }
    
}
