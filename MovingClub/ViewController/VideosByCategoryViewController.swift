//
//  VideosByCategoryViewController.swift
//  MovingClub
//
//  Created by Rohit Singh Dhakad  [C] on 06/09/25.
//

import UIKit

class VideosByCategoryViewController: UIViewController {
    
    @IBOutlet weak var cvVideos: UICollectionView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblChoosenExercise: UILabel!
    
    var strCategoryID = ""
    var arrVideos = [VideoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cvVideos.delegate = self
        self.cvVideos.dataSource = self
        
        self.call_Websercice_Video(strCategoryID: strCategoryID)
        let userName = objAppShareData.UserDetail.name?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.lblUserName.text = (userName?.isEmpty == false) ? "Hello\n\(userName ?? "") :)" : "Hello\nGuest :)"
        
    }
    
    @IBAction func btnOnGoBack(_ sender: Any) {
        self.onBackPressed()
    }
    
    @IBAction func btnOnReload(_ sender: Any) {
        self.call_Websercice_Video(strCategoryID: strCategoryID)
    }
    
    @IBAction func btnOnSideMenu(_ sender: Any) {
        
    }
    @IBAction func btnOnStartMoving(_ sender: Any) {
        let selectedVideos = arrVideos
            .filter { $0.isSelected }
            .compactMap { $0.videoURL } // assuming you have `videoURL` in your model
        
        if selectedVideos.isEmpty {
            self.showToast(message: "Please select at least one video", fontName: "CenturyGothic-Bold", fontSize: 14)
            return
        }
        
        // Navigate to player VC
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let playerVC = storyboard.instantiateViewController(withIdentifier: "VideoPlayerViewController") as? VideoPlayerViewController {
            playerVC.videoURLs = selectedVideos
            self.navigationController?.pushViewController(playerVC, animated: true)
        }
    }
    
}


extension VideosByCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideosByCategoryCollectionViewCell", for: indexPath) as! VideosByCategoryCollectionViewCell
        
        let obj = self.arrVideos[indexPath.row]
        
        let imageUrl = obj.thumbnailURL
        if imageUrl != "" {
            let url = URL(string: imageUrl ?? "")
            cell.imgvw.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
        }else{
            cell.imgvw.image = UIImage(named: "logo")
        }
        
        cell.imgvwCheckBox.isHidden = !obj.isSelected
        
        if obj.type == "Paid" {
            cell.vwLock.isHidden = false
        } else {
            cell.vwLock.isHidden = true
        }
        
        cell.btnShowImage.tag = indexPath.row
        cell.btnShowImage.addTarget(self, action: #selector(btnShowImageTapped(_:)), for: .touchUpInside)
        updateSelectedCount()
        
        return cell
    }
    
    @objc func btnShowImageTapped(_ sender: UIButton) {
        let index = sender.tag
        let obj = self.arrVideos[index]
        
        if let imageUrl = obj.thumbnailURL, let url = URL(string: imageUrl) {
            showImagePreview(url: url)
        }
    }
    
    private func updateSelectedCount() {
        let count = arrVideos.filter { $0.isSelected }.count
        lblChoosenExercise.text = "Chosen Exercises: \(count)"
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let obj = arrVideos[indexPath.row]
        // Prevent selection if video is "Paid"
        if obj.type == "Paid" {
            return false
        }
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.arrVideos[indexPath.row]
        // Toggle isSelected
        obj.isSelected.toggle()
        
        // Reload only that cell
        collectionView.reloadItems(at: [indexPath])
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow: CGFloat = 2
        let spacing: CGFloat = 10 // minimumInteritemSpacing
        let totalSpacing = (numberOfItemsPerRow - 1) * spacing
        
        let width = (collectionView.frame.width - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: width, height: 130) // height can be whatever you need
    }
    
    private func showImagePreview(url: URL) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        // Background overlay
        let bgView = UIView(frame: window.bounds)
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        bgView.alpha = 0
        window.addSubview(bgView)
        
        // ImageView
        let imageView = UIImageView(frame: bgView.bounds)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "logo"))
        bgView.addSubview(imageView)
        
        // Tap gesture to dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissImagePreview(_:)))
        bgView.addGestureRecognizer(tap)
        
        // Animate in
        UIView.animate(withDuration: 0.25) {
            bgView.alpha = 1
        }
    }
    
    @objc private func dismissImagePreview(_ sender: UITapGestureRecognizer) {
        if let bgView = sender.view {
            UIView.animate(withDuration: 0.25, animations: {
                bgView.alpha = 0
            }) { _ in
                bgView.removeFromSuperview()
            }
        }
    }

}

extension VideosByCategoryViewController {
    
    
    func call_Websercice_Video(strCategoryID: String) {
        
        if !objWebServiceManager.isNetworkAvailable(){
            objWebServiceManager.hideIndicator()
            objAlert.showAlert(message: "No Internet Connection", title: "Alert", controller: self)
        }
        
        objWebServiceManager.showIndicator()
        
        let dictParam = ["category_id": strCategoryID, "user_id": objAppShareData.UserDetail.strUserId ?? ""] as [String:Any]
        print(dictParam)
        
        objWebServiceManager.requestPost(strURL: WsUrl.url_getVideo, queryParams: [:], params: dictParam, strCustomValidation: "", showIndicator: false) { (response) in
            objWebServiceManager.hideIndicator()
            
            let status = (response["status"] as? Int)
            let message = (response["message"] as? String)
            print(response)
            
            if status == MessageConstant.k_StatusCode{
                if let resultArray = response["result"] as? [[String: Any]] {
                    self.arrVideos.removeAll()
                    for dict in resultArray {
                        let category = VideoModel(from: dict)
                        self.arrVideos.append(category)
                    }
                    print("Loaded \(self.arrVideos.count) categories")
                    self.cvVideos.reloadData()
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

