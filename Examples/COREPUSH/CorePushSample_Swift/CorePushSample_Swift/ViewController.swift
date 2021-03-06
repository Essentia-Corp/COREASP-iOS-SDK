//
//  ViewController.swift
//  CorePushSample_Swift
//
//  Copyright © 2017年 株式会社ブレスサービス. All rights reserved.
//

import UIKit
import COREASP
import CoreLocation

/**
    通知設定のビューコントローラ
 */
class ViewController: UIViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定";
        self.initLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //*********************************************************************************************
        // デバイストークンの登録・削除時の通知をNotificationCenterに登録する。
        //*********************************************************************************************
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.registerTokenRequestSuccess), name: NSNotification.Name.CorePushManagerRegisterTokenRequestSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.registerTokenRequestFail), name: NSNotification.Name.CorePushManagerRegisterTokenRequestFail, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.unregisterTokenRequestSuccess), name: NSNotification.Name.CorePushManagerUnregisterTokenRequestSuccess, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.unregisterTokenRequestFail), name: NSNotification.Name.CorePushManagerUnregisterTokenRequestFail, object: nil)
        
        // プッシュ通知のON・OFF制御
        if CorePushManager.shared.isDeviceTokenSentToServer {
            notificationSwitch.isOn = true
        } else {
            notificationSwitch.isOn = false
        }
    }
    func initLocation() {
        if (self.locationManager == nil){
            self.locationManager = CLLocationManager()
        }
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        self.locationManager.delegate = self;
        self.locationManager.startUpdatingLocation();
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     
        //*********************************************************************************************
        // デバイストークの登録・削除時の通知をNotificationCenterから解除する。
        //*********************************************************************************************
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerRegisterTokenRequestSuccess, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerRegisterTokenRequestFail, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerUnregisterTokenRequestSuccess, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.CorePushManagerUnregisterTokenRequestFail, object: nil)
    }
    
    
    @IBAction func valueChangeNotificationSwitch() {
        
        if notificationSwitch.isOn {
            
//            let categoryIds = ["0", "1", "2", "3", "4", "5"]
//            CorePushManager.shared.categoryIds = categoryIds
//            CorePushManager.shared.appUserId = "userid"
            
            //*********************************************************************************************
            // 通知の登録・デバイストークンをcore-aspサーバに登録
            //*********************************************************************************************
            CorePushManager.shared.registerForRemoteNotifications()
            
        } else {
            
            //*********************************************************************************************
            // デバイストークンをcore-aspサーバから削除
            //*********************************************************************************************
            CorePushManager.shared.unregisterDeviceToken()
        }
    }
}

// MARK: -  デバイストークンの登録・削除時の通知のセレクターの定義

extension ViewController {
    
    // デバイストークン登録成功時に呼び出される。
    @objc func registerTokenRequestSuccess() {
        notificationSwitch.isOn = true
        
        UIAlertView(title: "成功", message: "デバイストークンの登録に成功",
                    delegate: nil,
                    cancelButtonTitle:
            nil,
                    otherButtonTitles: "OK").show()
    }
    
    
    // デバイストークン登録失敗に呼び出される。
    @objc func registerTokenRequestFail() {
        notificationSwitch.isOn = false
        
        UIAlertView(title: "エラー", message: "デバイストークンの登録に失敗",
                    delegate: nil,
                    cancelButtonTitle:
            nil,
                    otherButtonTitles: "OK").show()
    }
    
    // デバイストークン削除成功時に呼び出される。
    @objc func unregisterTokenRequestSuccess() {
        notificationSwitch.isOn = false
        
        UIAlertView(title: "成功", message: "デバイストークンの削除に成功",
                    delegate: nil,
                    cancelButtonTitle:
            nil,
                    otherButtonTitles: "OK").show()
    }
    
    // デバイストークン削除失敗時に呼び出される。
    @objc func unregisterTokenRequestFail() {
        notificationSwitch.isOn = true
        UIAlertView(title: "エラー", message: "デバイストークンの削除に失敗",
                    delegate: nil,
                    cancelButtonTitle: nil,
                    otherButtonTitles: "OK").show()
    }
}

extension ViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations.last
        guard let location = locations.last else {
            return;
        }
        let latitude = String(format: "%.5f", location.coordinate.latitude)
        let longitude = String(format: "%.5f", location.coordinate.longitude)
        DispatchQueue.main.async {
            self.locationLabel.text = String(format: "ロケーション: (%@,%@)", latitude, longitude)
        }
        
        self.locationManager.delegate = nil
        self.locationManager = nil
    }
}
