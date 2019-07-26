//
//  ViewController.m
//  CorePushSample
//
//  Copyright (c) 2017 株式会社ブレスサービス. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"


@implementation ViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"設定";
        self.tabBarItem.image = [UIImage imageNamed:@"setting.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"設定";
    [self initLocation];
}

- (void)initLocation{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    // デバイストークの登録・削除時の通知をNotificationCenterに登録する。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerTokenRequestSuccess) name:CorePushManagerRegisterTokenRequestSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerTokenRequestFail) name:CorePushManagerRegisterTokenRequestFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregisterTokenRequestSuccess) name:CorePushManagerUnregisterTokenRequestSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregisterTokenRequestFail) name:CorePushManagerUnregisterTokenRequestFailNotification object:nil];
    
    if (CorePushManager.shared.isDeviceTokenSentToServer) {
        _notificationSwitch.on = YES;
    } else {
        _notificationSwitch.on = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    // NotificationCenterからデバイストークの登録・削除時の通知を解除する。
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerRegisterTokenRequestSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerRegisterTokenRequestFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerUnregisterTokenRequestSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerUnregisterTokenRequestFailNotification object:nil];
}

// プッシュ通知のON•OFFを切り替えたときに呼ばれる。
- (IBAction)valueChangeNotificationSwitch:(id)sender {
    
    if (_notificationSwitch.on) {
        
        //    NSArray* categoryids = @[@"0",@"1", @"2", @"3", @"4", @"5"];
        //    [CorePushManager.shared setCategoryIds:categoryids];
        //    [CorePushManager.shared setAppUserId:@"userid"];
        
        //*********************************************************************************************
        // 通知の登録・デバイストークンをcore-aspサーバに登録
        //*********************************************************************************************
        [[CorePushManager shared] registerForRemoteNotifications];
        
    } else {
        //*********************************************************************************************
        // デバイストークンをcore-aspサーバから削除
        //*********************************************************************************************
        [[CorePushManager shared] unregisterDeviceToken];
    }
    
}

// デバイストークン登録成功時に呼び出される。
- (void)registerTokenRequestSuccess {
    _notificationSwitch.on = YES;
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"デバイストークンの登録に成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
}

// デバイストークン登録失敗に呼び出される。
- (void)registerTokenRequestFail {
    _notificationSwitch.on = NO;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"デバイストークンの登録に失敗" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
}

// デバイストークン削除成功時に呼び出される。
- (void)unregisterTokenRequestSuccess {
    _notificationSwitch.on = NO;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"デバイストークンの削除に成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
}

// デバイストークン削除失敗時に呼び出される。
- (void)unregisterTokenRequestFail {
    _notificationSwitch.on = YES;
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"デバイストークンの削除に失敗" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert show];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *location = [locations lastObject];
    
    if (location != nil) {
        NSString *latitude = [NSString stringWithFormat:@"%.5f", location.coordinate.latitude];
        NSString *longitude = [NSString stringWithFormat:@"%.5f", location.coordinate.longitude];
    
        dispatch_async(dispatch_get_main_queue(), ^(void){
            self.locationLabel.text = [NSString stringWithFormat:@"ロケーション: (%@,%@)", latitude,longitude];
        });
        
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
    
}
@end
