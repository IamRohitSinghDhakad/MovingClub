//
//  SideMenuPresenterViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class SideMenuPresenter {

    // Add a configuration closure to allow callback
    static func present(from parent: UIViewController,
                        sideMenuIdentifier: String = "SideMenuViewController",
                        storyboardName: String = "Main",
                        widthFactor: CGFloat = 0.8,
                        configuration: ((SideMenuViewController) -> Void)? = nil) {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)

        guard let sideMenuVC = storyboard.instantiateViewController(withIdentifier: sideMenuIdentifier) as? SideMenuViewController else {
            print("⚠️ Could not find SideMenuViewController in storyboard.")
            return
        }

        // Call the closure to set up callbacks
        configuration?(sideMenuVC)
        
        // Container to hold menu + dimmed background
        let containerVC = UIViewController()
        containerVC.modalPresentationStyle = .overCurrentContext
        containerVC.view.backgroundColor = .clear
        
        // Dimmed background view
        let dimmedView = UIView(frame: parent.view.bounds)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedView.alpha = 0
        containerVC.view.addSubview(dimmedView)
        
        // Tap gesture to dismiss when tapping outside
        let tapGesture = UITapGestureRecognizer(target: containerVC, action: #selector(containerVC.dismissSelf))
        dimmedView.addGestureRecognizer(tapGesture)
        
        // Add SideMenu as child
        containerVC.addChild(sideMenuVC)
        containerVC.view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: containerVC)
        
        // Set initial frame offscreen
        let menuWidth = parent.view.frame.width * widthFactor
        sideMenuVC.view.frame = CGRect(x: -menuWidth,
                                       y: 0,
                                       width: menuWidth,
                                       height: parent.view.frame.height)
        
        parent.present(containerVC, animated: false) {
            UIView.animate(withDuration: 0.3, animations: {
                sideMenuVC.view.frame.origin.x = 0
                dimmedView.alpha = 1
            })
        }
    }
}

// MARK: - UIViewController extension for dismiss animation
extension UIViewController {
    @objc func dismissSelf() {
        guard let dimmedView = view.subviews.first,
              let menuView = view.subviews.last else {
            dismiss(animated: false, completion: nil)
            return
        }

        UIView.animate(withDuration: 0.3, animations: {
            menuView.frame.origin.x = -menuView.frame.width
            dimmedView.alpha = 0
        }, completion: { _ in
            self.dismiss(animated: false, completion: nil)
        })
    }
}
