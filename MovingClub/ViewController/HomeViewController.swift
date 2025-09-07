//
//  HomeViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var cvCategories: UICollectionView!
    var arrCategories = [CategoryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cvCategories.delegate = self
        self.cvCategories.dataSource = self
        self.call_Websercice_Categories()
    }
    
    @IBAction func btnReload(_ sender: Any) {
        self.call_Websercice_Categories()
    }
    
    @IBAction func btnOpenSideMenu(_ sender: Any) {
        // Do login / register validation here
        SideMenuManager.shared.showMenu(from: self)
    }
    
    
    @IBAction func btnStartMoving(_ sender: Any) {
        let selectedIDs = arrCategories
                .filter { $0.isSelected }
                .compactMap { $0.categoryID }
                .joined(separator: ",")

            if selectedIDs.isEmpty {
                self.showToast(message: "Please select category", fontName: "CenturyGothic", fontSize: 16)
            //showToast(message: "Please select category")
            } else {
                print("✅ Selected IDs: \(selectedIDs)")
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "VideosByCategoryViewController") as! VideosByCategoryViewController
                vc.strCategoryID = selectedIDs
                self.navigationController?.pushViewController(vc, animated: true)
                
                // Continue your navigation or API call
            }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as! HomeCollectionViewCell
        
        let category = arrCategories[indexPath.item]
        cell.lbltitle.text = category.categoryName
        
        let imageUrl = category.categoryImage
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgvw.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
        }else{
            cell.imgvw.image = UIImage(named: "logo")
        }
        
        cell.imgVwCheckBox.isHidden = !category.isSelected
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = arrCategories[indexPath.item]
        // Toggle isSelected
        category.isSelected.toggle()
        
        // Reload only that cell
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 3
        let spacing: CGFloat = 10 // minimumInteritemSpacing
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: 170) // height can be whatever you need
    }
    
}

extension HomeViewController {
    
    
    func call_Websercice_Categories() {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = [String:Any]()
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getCategory, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [[String: Any]] {
                    self.arrCategories.removeAll()
                    for dict in resultArray {
                        let category = CategoryModel(from: dict)
                        self.arrCategories.append(category)
                    }
                    print("Loaded \(self.arrCategories.count) categories")
                    self.cvCategories.reloadData()
                }
            }else{
                objAlert.showAlert(message: message ?? "", title: "Alert", controller: self)
            }
        } failure: { (error) in
            objWebServiceManager.hideIndicator()
            print("Error \(error)")
            
            
        }
    }
}

