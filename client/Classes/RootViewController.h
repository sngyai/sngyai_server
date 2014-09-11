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
#import "MiidiAdWallGetPointsDelegate.h"
#import "MiidiAdWallAwardPointsDelegate.h"
#import "MiidiAdWallSpendPointsDelegate.h"
#import "MiidiAdWallShowAppOffersDelegate.h"
#import "MiidiAdWallRequestToggleDelegate.h"
#import "DMOfferWallManager.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"


// aliyun服务器
#define HOST (@"http://123.57.9.112:8088/")

// Window台式机
//#define HOST (@"http://192.168.1.7:8088/")

// MacMini
//#define HOST (@"http://192.168.1.4:8088/")

@interface RootViewController : UITabBarController
<MiidiAdWallShowAppOffersDelegate
, MiidiAdWallAwardPointsDelegate
, MiidiAdWallSpendPointsDelegate
, MiidiAdWallGetPointsDelegate
, MiidiAdWallRequestToggleDelegate
, DMOfferWallManagerDelegate
, GuoMobWallDelegate>
{
    GuoMobWallViewController * _guomobwall_vc;
    DMOfferWallManager*_offerWallManager;
    NSNumber *_score;
}

-(void) queryScore;

@property(nonatomic,copy)GuoMobWallViewController *guomobwall_vc;
@property(nonatomic,copy)DMOfferWallManager *offerWallManager;
@property(nonatomic,copy)NSNumber *score;

@end
