//
//  VideoPlayerViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

//
//  VideoPlayerViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit
import AVKit

class VideoPlayerViewController: UIViewController {
    
    var videoURLs: [String] = []
    private var currentIndex = 0
    private var player: AVPlayer?
    private var playerViewController: AVPlayerViewController?
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "CenturyGothic-Bold", size: 16)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 8
        label.clipsToBounds = true
        return label
    }()
    
    private let loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        setupUI()
        playVideo(at: currentIndex)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = .allButUpsideDown
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.orientationLock = .portrait   // back to portrait for rest of the app
        }
    }
    
    deinit {
        if let item = player?.currentItem {
            item.removeObserver(self, forKeyPath: "status")
            item.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            item.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
        }
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        // Progress Label
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            progressLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            progressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressLabel.heightAnchor.constraint(equalToConstant: 35),
            progressLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
        
        // Loader
        loader.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Close button
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            closeButton.widthAnchor.constraint(equalToConstant: 36),
            closeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func updateProgressLabel() {
        let total = videoURLs.count
        let remaining = total - currentIndex - 1
        
        if remaining > 0 {
            progressLabel.text = "▶️ Playing \(currentIndex + 1) of \(total) (\(remaining) left)"
        } else {
            progressLabel.text = "▶️ Playing last video"
        }
    }
    
    // MARK: - Video Handling
    private func playVideo(at index: Int) {
        guard index < videoURLs.count,
              let url = URL(string: videoURLs[index]) else { return }
        
        loader.startAnimating()
        
        player = AVPlayer(url: url)
        player?.automaticallyWaitsToMinimizeStalling = false // Helps with slow playback
        
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player
        playerViewController?.showsPlaybackControls = true
        
        updateProgressLabel()
        
        if let pvc = playerViewController {
            addChild(pvc)
            pvc.view.frame = view.bounds
            view.insertSubview(pvc.view, belowSubview: progressLabel)
            pvc.didMove(toParent: self)
            
            // Observe item status & buffering
            pvc.player?.currentItem?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
            pvc.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: [.new], context: nil)
            pvc.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: [.new], context: nil)
            
            // Observe when finished
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(videoDidFinish),
                name: .AVPlayerItemDidPlayToEndTime,
                object: pvc.player?.currentItem
            )
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let item = object as? AVPlayerItem else { return }

        switch keyPath {
        case "status":
            if item.status == .readyToPlay {
                loader.stopAnimating()
                player?.play()
            }

        case "playbackBufferEmpty":
            if item.isPlaybackBufferEmpty {
                loader.startAnimating()
            }

        case "playbackLikelyToKeepUp":
            loader.stopAnimating()
            if player?.timeControlStatus != .playing {
                player?.play() // resume only if not already playing
            }

        default:
            break
        }
    }

    
    @objc private func videoDidFinish() {
        currentIndex += 1
        if currentIndex < videoURLs.count {
            // Remove old player
            playerViewController?.willMove(toParent: nil)
            playerViewController?.view.removeFromSuperview()
            playerViewController?.removeFromParent()
            
            playVideo(at: currentIndex)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func closeTapped() {
        if let nav = navigationController {
            nav.popViewController(animated: true)   // If pushed
        } else {
            dismiss(animated: true, completion: nil) // If presented modally
        }
    }

    
    // MARK: - Orientation Lock
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
}
