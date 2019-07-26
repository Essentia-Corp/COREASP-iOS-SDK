//
//  ViewController.h
//  CorePushSample
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UISwitch* notificationSwitch;
@property (assign, nonatomic) id delegate;
@property (nonatomic, strong) CLLocationManager             *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

// スイッチをON・OFFに切り替えた時に呼ばれる
- (IBAction)valueChangeNotificationSwitch:(id)sender;

//*********************************************************************************************
// デバイストークの登録・削除の通知で呼び出すメソッド
//- (void)registerTokenRequestSuccess;
//- (void)registerTokenRequestFail;
//- (void)unregisterTokenRequestSuccess;
//- (void)unregisterTokenRequestFail;
//*********************************************************************************************

@end
