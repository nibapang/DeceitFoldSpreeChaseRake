//
//  WelcomeVC.swift
//  DeceitFoldSpreeChaseRake
//
//  Created by DeceitFoldSpree ChaseRake on 2025/3/10.
//


import UIKit

class ChaseRakeWelcomeVC: UIViewController {

    //MARK: - Declare IBOutlets
    
    @IBOutlet weak var contentView: UIStackView!
    
    //MARK: - Declare Variables
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    //MARK: - Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            self.contentView.axis = .horizontal
        } else {
            self.contentView.axis = .vertical
        }
        
        self.activityView.hidesWhenStopped = true
        self.chaseRakeNeedsShowAdsLocalData()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                self.contentView.axis = .horizontal
            } else {
                self.contentView.axis = .vertical
            }
        }, completion: nil)
    }
    
    //MARK: - Functions
    private func chaseRakeNeedsShowAdsLocalData() {
        guard self.chaseRakeNeedShowAdsView() else {
            return
        }
        self.activityView.startAnimating()
        chaseRakePostAppDeviceData { adsData in
            if let adsData = adsData, let adsUr = adsData[0] as? String {
                self.chaseRakeShowAdView(adsUr)
                UserDefaults.standard.set(adsData, forKey: "adsData")
            }
            self.activityView.stopAnimating()
        }
    }

    private func chaseRakePostAppDeviceData(completion: @escaping ([Any]?) -> Void) {
        guard self.chaseRakeNeedShowAdsView() else {
            return
        }
        
        let url = URL(string: "https://open.vftsy\(self.chaseRakeMainHost())/open/chaseRakePostAppDeviceData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "AppModel": UIDevice.current.model,
            "appKey": "e7001e24046a4ad4a74e1a558ae10f91",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? ""
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }
    
    //MARK: - Declare IBAction
    
}
