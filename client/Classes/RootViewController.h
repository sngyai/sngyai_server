//
//  RootViewController.h
//  MiidiSdkSample_Wall
//
//  Created by adpooh miidi on 12-5-20.
//  Copyright 2012 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AdSupport/ASIdentifierManager.h>
#import "YouMiWall.h"
#import "MiidiAdSpot.h"
#import "MiidiAdWall.h"
#import "CSAppZone.h"
#import "MiidiManager.h"
#import "GuoMobWallViewController.h"
//#import "MobiSageJoyViewController.h"
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "AssetZoneManager.h"
#import "QMRecommendApp.h"
#import <MBJoy/MBJoyView.h>
#import "CoolAdWall.h"
#import "MopanAdWall.h"

//#import "WPLib/AppConnect.h"

#import "ASIHTTPRequest.h"
#import "JSONKit.h"


// aliyun服务器
#define HOST (@"http://123.57.9.112:8088/")

// Window台式机
//#define HOST (@"http://192.168.1.3:8088/")

// MacMini
//#define HOST (@"http://192.168.1.108:8088/")

@interface RootViewController : UITabBarController
<MiidiAdWallShowAppOffersDelegate
, MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate
, MiidiAdWallRequestToggleDelegate
, AssetZoneManagerDelegate
//, MobiSageJoyDelegate
, QMRecommendAppDelegate
, GuoMobWallDelegate
, MBJoyViewDelegate
, MopanAdWallDelegate
, CoolAdWallDelegate
>
{
    GuoMobWallViewController * _guomobwall_vc;
//    MobiSageJoyViewController *_mobisagejoy;
    QMRecommendApp *_qumiViewController;
    AssetZoneManager*_offerWallManager;
    MBJoyView *_adWall;
    CoolAdWall * _kgad;
    MopanAdWall *_mopanAdWallControl;
    
    NSNumber *_score;
    NSString *_userName;
    NSString *_alipay;
}

-(void) queryScore;
-(void) getAccount;

@property(nonatomic,copy)GuoMobWallViewController *guomobwall_vc;
//@property(nonatomic,copy)MobiSageJoyViewController *mobisagejoy;
@property(nonatomic,copy)AssetZoneManager *offerWallManager;
@property(nonatomic,copy)QMRecommendApp *qumiViewController;
@property(nonatomic,copy)MBJoyView *adWall;
@property(nonatomic,copy)CoolAdWall *kgad;
@property(nonatomic,copy)MopanAdWall *mopanAdWallControl;

@property(nonatomic,copy)NSNumber *score;
@property(nonatomic,copy)NSString *alipay;
@property(nonatomic,copy)NSString *userName;

@end
