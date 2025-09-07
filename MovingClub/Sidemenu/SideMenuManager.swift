//
//  SideMenuManager.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import Foundation
import UIKit

struct MenuItem {
    let title: String
    let storyboardID: String?   // Optional VC identifier
    let iconInactive: String?   // Optional image name
    let iconActive: String?     // Optional image name
}

class SideMenuManager {

    static let shared = SideMenuManager()
    private init() {
        setupDefaultMenu()
    }

    private var menuItems: [MenuItem] = []
    private var viewControllerCache: [String: UIViewController] = [:]

    // MARK: - Default Menu Setup
    private func setupDefaultMenu() {
        menuItems = [
            MenuItem(title: "Home", storyboardID: "HomeViewController", iconInactive: "home_inactive", iconActive: "home_active"),
            MenuItem(title: "My Subscription", storyboardID: "MySubscriptionViewController", iconInactive: "profile_inactive", iconActive: "profile_active"),
            MenuItem(title: "About Us", storyboardID: "AboutViewController", iconInactive: "settings_inactive", iconActive: "settings_active"),
            MenuItem(title: "Privacy Policy", storyboardID: "PrivacyPolicyViewController", iconInactive: "privacy_inactive", iconActive: "privacy_active"),
            MenuItem(title: "Important Instructions", storyboardID: "ImportantInstructionViewController", iconInactive: "info_inactive", iconActive: "info_active"),
            MenuItem(title: "Logout", storyboardID: nil, iconInactive: "logout_inactive", iconActive: "logout_active")
        ]
    }

    // MARK: - Show Side Menu
    func showMenu(from parent: UIViewController, widthFactor: CGFloat = 0.8) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let sideMenuVC = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as? SideMenuViewController else {
            print("⚠️ Could not find SideMenuViewController")
            return
        }

        sideMenuVC.menuItems = menuItems
        sideMenuVC.onMenuItemSelected = { [weak self] item in
            self?.handleMenuSelection(item, from: parent)
        }

        // Container + dimmed background
        let containerVC = UIViewController()
        containerVC.modalPresentationStyle = .overCurrentContext
        containerVC.view.backgroundColor = .clear

        let dimmedView = UIView(frame: parent.view.bounds)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        dimmedView.alpha = 0
        containerVC.view.addSubview(dimmedView)

        let tapGesture = UITapGestureRecognizer(target: containerVC, action: #selector(containerVC.dismissSelf))
        dimmedView.addGestureRecognizer(tapGesture)

        containerVC.addChild(sideMenuVC)
        containerVC.view.addSubview(sideMenuVC.view)
        sideMenuVC.didMove(toParent: containerVC)

        let menuWidth = parent.view.frame.width * widthFactor
        sideMenuVC.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: parent.view.frame.height)

        parent.present(containerVC, animated: false) {
            UIView.animate(withDuration: 0.3) {
                sideMenuVC.view.frame.origin.x = 0
                dimmedView.alpha = 1
            }
        }
    }

    // MARK: - Handle Menu Selection
    private func handleMenuSelection(_ item: MenuItem, from parent: UIViewController) {

        if item.title == "Logout" {
            showLogoutConfirmation(from: parent)
            return
        }

        guard let storyboardID = item.storyboardID else { return }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardID)

        if let nav = parent.navigationController {
            // ✅ Prevent pushing same controller again
            if let topVC = nav.topViewController,
               type(of: topVC) == type(of: vc) {
                print("⚠️ Already on \(storyboardID), skipping push")
                return
            }
            nav.pushViewController(vc, animated: true)
        } else {
            parent.present(vc, animated: true)
        }
    }


    // MARK: - Logout Confirmation
    private func showLogoutConfirmation(from parent: UIViewController) {
        let alert = UIAlertController(title: "Logout",
                                      message: "Are you sure you want to logout?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.performLogout(from: parent)
        })
        parent.present(alert, animated: true)
    }

    private func performLogout(from parent: UIViewController) {
       
    }
}

