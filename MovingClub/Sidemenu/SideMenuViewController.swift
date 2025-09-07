//
//  SideMenuViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var vwTop: UIView!
    @IBOutlet weak var tblVw: UITableView!
    
    var menuItems: [MenuItem] = []
    var onMenuItemSelected: ((MenuItem) -> Void)?
    private var selectedIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblVw.delegate = self
        self.tblVw.dataSource = self
        
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell", for: indexPath)as! SideMenuTableViewCell
        
        let item = menuItems[indexPath.row]
        // let isActive = indexPath.row == selectedIndex
        
        cell.lblTitle?.text = item.title
        // cell.imageView?.image = UIImage(named: isActive ? item.iconActive : item.iconInactive)
        
        // Optional: Style text when active
        // cell.textLabel?.textColor = isActive ? .systemBlue : .label
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        tableView.reloadData()
        
        let selectedItem = menuItems[indexPath.row]
        print("Selected menu: \(selectedItem.title)")
        
        if selectedItem.title == "Logout" {
            showLogoutConfirmation()
        } else {
            // Use custom animation instead of default dismissal
            // Call the closure to notify parent VC
            self.onMenuItemSelected?(selectedItem)
            self.dismissSelf()
        }
    }
    
    
    private func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            self.performLogout()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func performLogout() {
        // Example API call
        // Replace with your real networking code
        print("🔗 Calling logout API...")
        
        // Simulate API response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // On success: clear session & navigate to login
            self.navigateToLogin()
        }
    }
    
    private func navigateToLogin() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }
}
